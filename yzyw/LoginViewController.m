//
//  LoginViewController.m
//  Garden
//
//  Created by 金学利 on 8/7/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface LoginViewController ()
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *textBack;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *timerBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, assign) NSInteger type;
@end

@implementation LoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        _count = 60;
        _type = 0;
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
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.logoView];
    [self.scrollView addSubview:self.titleLabel];
    
    [self.scrollView addSubview: self.textBack];
    [self.textBack addSubview:self.phoneTextField];
    [self.textBack addSubview:self.timerBtn];
    [self.textBack addSubview:self.line];
    [self.textBack addSubview:self.codeTextField];
    [self.scrollView addSubview:self.submitBtn];
    [self.scrollView addSubview:self.changeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UserAction
- (void)getCode:(UIButton *)sender
{
    if (![_phoneTextField.text ew_checkPhoneNumber]) {
        [self showErrorStatusWithTitle:@"请输入正确的手机号"];
        return;
    }
    
    //request
    [HTTPManager getCodeWithPhone:_phoneTextField.text type:@"5" success:^(id response) {
    
        DBLog(@"response=%@",response);
        
        if (response[@"errmsg"] != nil) {
            
            [self showErrorStatusWithTitle:response[@"errmsg"]];
            
        }else{
            //btn status
            _timerBtn.enabled = NO;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        }
        
        
    } failure:^(NSError *err) {
        DBError(err);
        
    }];
    
}

- (void)submit:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (_type == 0) {
        if ([_codeTextField.text ew_removeSpacesAndLineBreaks].length <=0) {
            [self showErrorStatusWithTitle:@"请输入验证码"];
            return;
        }

    }else{
        if ([_codeTextField.text ew_removeSpacesAndLineBreaks].length <=0) {
            [self showErrorStatusWithTitle:@"请输入密码"];
            return;
        }

    }
    
    [self showLoading];
    
    //request
    [HTTPManager loginWithPhone:_phoneTextField.text code:_codeTextField.text type:_type success:^(id response) {
        [self hideLoading];
        
        DBLog(@"response===%@",response);
        
        if (response[@"errmsg"]!=nil) {
            [self showErrorStatusWithTitle:response[@"errmsg"]];
        }else{
            [self showSuccessStatusWithTitle:@"登录成功"];
            [EWUtils setObject:@"1" key:SHOULDINIT];
            [EWUtils setObject:@"1" key:USERHASLOGIN];
            
            // SAVE USER INFO
            [VGUtils saveUserData:response];
            
            //REFERSH HOME DATA & USER PAGE
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHHOMEDATA" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERPAGE" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHTCPAGE" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCAIHOMEDATA" object:nil];
            //BACK
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clickLeftBarButton:nil];
            });
        }
        
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

- (void)changeType:(UIButton *)sender
{
    self.codeTextField.text = nil;
    if (_type == 0) {
        _type = 1;
        [sender setTitle:@"验证码登录" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.codeTextField.placeholder = @"请输入密码";
            self.timerBtn.hidden = YES;
            self.codeTextField.secureTextEntry = YES;
            self.codeTextField.keyboardType = UIKeyboardTypeDefault;
            self.phoneTextField.frame = CGRectMake(18, 0, self.textBack.width-36, 56);
            [self.view bringSubviewToFront:self.phoneTextField];
        }];
        
        
    }else{
        _type = 0;
        [sender setTitle:@"密码登录" forState:UIControlStateNormal];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            self.codeTextField.placeholder = @"请输入验证码";
            self.timerBtn.hidden = NO;
            self.codeTextField.secureTextEntry = NO;
            self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.phoneTextField.frame = CGRectMake(18, 0, 180, 56);

        }];

    }
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

- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        _backView.userInteractionEnabled = YES;
        //_backView.image = [UIImage ew_imageWithContentOfFile:@"login_back@2x.png"];
    }
    return _backView;
}


- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2.0, 44, 150, 150)];
        _logoView.image = [UIImage imageNamed:@"icon_small_logo"];
    }
    return _logoView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.logoView.bottom+5, SCREEN_WIDTH, 0)];
        _titleLabel.font = FONT(14);
        //_titleLabel.text = @"登录后，可以购买套餐和选品";
        _titleLabel.textColor = BLACK_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)textBack
{
    if (!_textBack) {
        _textBack = [[UIView alloc] initWithFrame:CGRectMake(15, self.titleLabel.bottom+5, SCREEN_WIDTH-30, 224/2.0)];
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
//        [_timerBtn setTitleColor:RGB_COLOR(48, 48, 48) forState:UIControlStateNormal];
        [_timerBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIButton *)changeBtn
{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.backgroundColor = CLEAR_COLOR;
        [_changeBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = FONT(12);
        [_changeBtn setTitleColor:RGB_COLOR(40, 40, 40) forState:UIControlStateNormal];
        _changeBtn.frame = CGRectMake((self.view.width-100)/2.0, self.submitBtn.bottom+20, 100, 30);
        [_changeBtn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setImage:[UIImage imageNamed:@"login_arrow.png"] forState:UIControlStateNormal];
        _changeBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _changeBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _changeBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);

    }
    return _changeBtn;
}

@end
