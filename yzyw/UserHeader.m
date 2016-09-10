#import "UserHeader.h"

@interface UserHeader ()
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *loginLabel;
@end

@implementation UserHeader

-(instancetype)initWithFrame:(CGRect)frame  //350+222+15
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITE_COLOR;
        [self addSubview:self.backView];
        [self.backView addSubview:self.avatar];
        [self.backView addSubview:self.phoneLabel];
        [self.avatar addSubview:self.loginLabel];
    }
    return self;
}


- (void)configUserHeader:(id)data
{
    if ([VGUtils userHasLogin]) {
        self.avatar.userInteractionEnabled = YES;
        self.loginLabel.hidden = YES;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[EWUtils getObjectForKey:USERHEADIMG]] placeholderImage:[UIImage imageNamed:@"user_avatar"]];
        self.phoneLabel.text = [EWUtils getObjectForKey:USERMOBILE];

    }else{
        self.avatar.userInteractionEnabled = YES;
        self.loginLabel.hidden = NO;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350/2.0);
    self.avatar.frame = CGRectMake((SCREEN_WIDTH-80)/2.0, 45, 80, 80);
    self.loginLabel.frame = CGRectMake(0, (self.avatar.height-20)/2.0, self.avatar.width, 20);
    self.phoneLabel.frame = CGRectMake(0, self.avatar.bottom+5, SCREEN_WIDTH, 15);
}

#pragma mark - gesture
- (void)login
{
    [_delegate login];
}

#pragma mark - Getter
- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backView.image = [UIImage imageNamed:@"user_header"];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = WHITE_COLOR;
    }
    return _backView;
}


- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 40;
        _avatar.backgroundColor = WHITE_COLOR;
        _avatar.layer.borderColor =RGB_COLOR(191, 191, 191).CGColor;
        _avatar.layer.borderWidth = 1;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
        [_avatar addGestureRecognizer:tap];
        tap = nil;
        
    }
    return _avatar;
}


- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneLabel.font = FONT(14);
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.textColor = RGB_COLOR(68, 102, 40);
    }
    return _phoneLabel;
}


- (UILabel *)loginLabel
{
    if (!_loginLabel) {
        _loginLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loginLabel.font = FONT(16);
        _loginLabel.textColor = RGB_COLOR(68, 102, 40);
        _loginLabel.textAlignment = NSTextAlignmentCenter;
        _loginLabel.text = @"点击登录";
    }
    return _loginLabel;
}

@end
