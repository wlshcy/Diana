#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Lockbox.h"

@interface LoginViewController ()
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIView *textBack;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *timerBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *line;
@end

@implementation LoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        _count = 60;
        [self layoutNavigationBar];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetTimer];
}

- (void)configView
{
    self.view.backgroundColor = WHITE_COLOR;
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview: self.textBack];
    [self.textBack addSubview:self.phoneTextField];
    [self.textBack addSubview:self.timerBtn];
    [self.textBack addSubview:self.line];
    [self.textBack addSubview:self.codeTextField];
    [self.scrollView addSubview:self.submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UserAction
- (void)getSMSCode:(UIButton *)sender
{
    if (![_phoneTextField.text ew_checkPhoneNumber]) {
        [self showErrorStatusWithTitle:@"请输入正确的手机号"];
        return;
    }
    
    //request
    [HTTPManager getSMSCode:_phoneTextField.text success:^(id response) {
        
        if (response[@"errmsg"] != nil) {
            
            [self showErrorStatusWithTitle:response[@"errmsg"]];
            
        }else{
            _timerBtn.enabled = NO;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSError *err) {

        [self showErrorStatusWithTitle:@"获取验证码失败"];
        
    }];
    
}

- (void)submit:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([_codeTextField.text ew_removeSpacesAndLineBreaks].length <=0) {
            [self showErrorStatusWithTitle:@"请输入验证码"];
            return;
    }

    [self showLoading];
    
    //request
    [HTTPManager loginWithSMSCode:_phoneTextField.text code:_codeTextField.text success:^(id response) {
        [self hideLoading];
        DBLog(@"%@", response[@"token"]);
        [Lockbox archiveObject:[NSString stringWithFormat:@"%@", response[@"token"]] forKey:@"token"];
        [self.navigationController popViewControllerAnimated:true];
    } failure:^(NSError *err) {
        [self hideLoading];
        [self showFailureStatusWithTitle:NET_TIPS];
    }];

}



- (void)timeCount
{
    _count --;
    NSString *str = [NSString stringWithFormat:@"%@秒",@(_count)];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (IOS8Later) {
            [_timerBtn setTitle:str forState:UIControlStateNormal];
        }else{
            _timerBtn.titleLabel.text = str;

        }
        
        [_timerBtn setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
        
    });
    
    if (_count == 0) {
        [self resetTimer];
        _count = 60;
        _timerBtn.enabled = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (IOS8Later) {
                [_timerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            }else{
                _timerBtn.titleLabel.text = @"获取验证码";
            }
            
            [_timerBtn setTitleColor:RGB_COLOR(17,194,88)  forState:UIControlStateNormal];
        });
        
    }
    
}

- (void)resetTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)clickLeftBarButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (TPKeyboardAvoidingScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = CLEAR_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = CLEAR_COLOR;
    }
    return _scrollView;
}

- (UIView *)textBack
{
    if (!_textBack) {
        _textBack = [[UIView alloc] initWithFrame:CGRectMake(15, (SCREEN_HEIGHT-50)/5, SCREEN_WIDTH-30, 224/2.0)];
        _textBack.backgroundColor = WHITE_COLOR;
        _textBack.layer.borderColor = RGB_COLOR(206, 206, 206).CGColor;
        _textBack.layer.borderWidth = 1;
    }
    return _textBack;
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, 180, 56)];
        _phoneTextField.font = FONT(15);
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.placeholder = @"输入手机号";
    }
    return _phoneTextField;
}

- (UIButton *)timerBtn
{
    if (!_timerBtn) {
        _timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timerBtn.frame = CGRectMake(self.textBack.width-18-80,0, 80, 56);
        [_timerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _timerBtn.titleLabel.font = FONT(15);
        [_timerBtn setTitleColor:RGB_COLOR(48, 48, 48) forState:UIControlStateNormal];
        [_timerBtn addTarget:self action:@selector(getSMSCode:) forControlEvents:UIControlEventTouchUpInside];
        [_timerBtn setTitleColor:RGB_COLOR(17,194,88)  forState:UIControlStateNormal];
    }
    return _timerBtn;
}

- (UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 56, self.textBack.width-36, 56)];
        _codeTextField.font = FONT(15);
        _codeTextField.placeholder = @"验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(18, 56, self.textBack.width-36, 1)];
        _line.backgroundColor = RGB_COLOR(199, 199, 199);
    }
    return _line;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(15, self.textBack.bottom+15, SCREEN_WIDTH-30, 55);
        _submitBtn.backgroundColor = WHITE_COLOR;
        [_submitBtn setTitleColor:RGB_COLOR(48, 48, 48) forState:UIControlStateNormal];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = BFONT(15);
        [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.borderColor = RGB_COLOR(206, 206, 206).CGColor;
        _submitBtn.layer.borderWidth = 1;
    }
    return _submitBtn;
}
@end
