//
//  UserHeader.m
//  Garden
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import "UserHeader.h"

@interface UserHeader ()
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIView *dataView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *submitBtn;


//add
@property (nonatomic, strong) UIView *redView;

@end

@implementation UserHeader

-(instancetype)initWithFrame:(CGRect)frame  //350+222+15
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITE_COLOR;
        [self addSubview:self.backView];
        [self.backView addSubview:self.avatar];
        [self.backView addSubview:self.phoneLabel];
        //[self.backView addSubview:self.addressLabel];
        [self.avatar addSubview:self.tipsLabel];
        [self.backView addSubview:self.redView];
        
//        [self addSubview:self.dataView];
//        [self.dataView addSubview:self.titleLabel];
//        [self.dataView addSubview:self.nameLabel];
//        [self.dataView addSubview:self.desLabel];
//        [self.dataView addSubview:self.numberLabel];
//        [self.dataView addSubview:self.submitBtn];
    
        
        
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = RGB_COLOR(242, 242, 242).CGColor;
    }
    return self;
}


- (void)configUserHeader:(id)data
{

    
    
    if ([VGUtils userHasLogin]) {
        self.avatar.userInteractionEnabled = YES;
        self.tipsLabel.hidden = YES;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[EWUtils getObjectForKey:USERHEADIMG]] placeholderImage:[UIImage imageNamed:@"user_avatar"]];
        self.phoneLabel.text = [EWUtils getObjectForKey:USERMOBILE];
        self.addressLabel.text = [EWUtils getObjectForKey:USERADDRESS];
        
        
        self.redView.hidden = NO;

    }else{
        self.avatar.userInteractionEnabled = YES;
        self.tipsLabel.hidden = NO;
        self.redView.hidden = YES;
    }
    
//    self.titleLabel.text = @"您购买的套餐";
//    self.nameLabel.text = @"阖家幸福套餐";
//    self.desLabel.text = @"每周配送1次  每次6斤";
//    self.numberLabel.text = @"4次/月   共30斤";
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350/2.0);
    self.avatar.frame = CGRectMake((SCREEN_WIDTH-80)/2.0, 45, 80, 80);
    self.redView.frame = CGRectMake(self.avatar.right-16, self.avatar.top+10, 10, 10);
    self.tipsLabel.frame = CGRectMake(0, (self.avatar.height-20)/2.0, self.avatar.width, 20);
    self.phoneLabel.frame = CGRectMake(0, self.avatar.bottom+5, SCREEN_WIDTH, 15);
    self.addressLabel.frame = CGRectMake(0, self.phoneLabel.bottom, SCREEN_WIDTH, 20);
    self.dataView.frame = CGRectMake(10, _backView.bottom+7.5, SCREEN_WIDTH-20, 111);
    
    self.titleLabel.frame = CGRectMake(16, 20, 150, 10);
    self.nameLabel.frame = CGRectMake(16, self.titleLabel.bottom+10, 150, 20);
    self.desLabel.frame = CGRectMake(16, self.nameLabel.bottom+5, 150, 12);
    self.numberLabel.frame = CGRectMake(16, self.desLabel.bottom+5, 150, 12);
    self.submitBtn.frame = CGRectMake(self.dataView.width-194/2.0-16, (self.dataView.height-33)/2.0, 194/2.0, 33);
}

#pragma mark - gesture
- (void)tapAvatar
{
    [_delegate didTapUserHeader];
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
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)];
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

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.font = FONT(14);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = RGB_COLOR(68, 102, 40);
    }
    return _addressLabel;
}



- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.font = FONT(16);
        _tipsLabel.textColor = RGB_COLOR(68, 102, 40);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"微信登录";
    }
    return _tipsLabel;
}


- (UIView *)dataView
{
    if (!_dataView) {
        _dataView = [[UIView alloc] initWithFrame:CGRectZero];
        _dataView.backgroundColor = WHITE_COLOR;//RGB_COLOR(244, 244, 244);
    }
    return _dataView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT(10);
        _titleLabel.textColor = BLACK_COLOR;
    }
    return _titleLabel;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT(16);
    }
    return _nameLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.font = FONT(12);
    }
    return _desLabel;
}


- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT(12);
    }
    return _numberLabel;
}


- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.borderColor = RGB_COLOR(206, 201,194).CGColor;
        _submitBtn.layer.borderWidth = 1;
        _submitBtn.layer.cornerRadius = 3;
        _submitBtn.clipsToBounds = YES;
        _submitBtn.titleLabel.font = FONT(11);
        [_submitBtn setTitle:@"您已选择本期菜品" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:RGB_COLOR(169, 169, 169) forState:UIControlStateNormal];
        _submitBtn.enabled = NO;
    }
    return _submitBtn;
}

- (UIView *)redView
{
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = RED_COLOR;
        _redView.clipsToBounds = YES;
        _redView.layer.cornerRadius = 5;
    }
    return _redView;
}

@end
