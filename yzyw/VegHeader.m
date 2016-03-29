//
//  VegHeader.m
//  Lynp
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import "VegHeader.h"
#import "VegDetailViewController.h"

@interface VegHeader()<EWFocusViewDataSource,EWFocusViewDelegate>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) EWFocusView *focusView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *slideData;
@property (nonatomic, strong) CaiHomeData *homeData;
@end

@implementation VegHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB_COLOR(245, 245, 245);
        _slideData = [NSMutableArray arrayWithCapacity:10];
        
        [self addSubview:self.focusView];
        //[self addSubview:self.topImageView];
        
        //[self addSubview:self.bottomView];
        
        //[self.bottomView addSubview:self.titleLabel];
        //[self.bottomView addSubview:self.allCaiBtn];
        //[self.bottomView addSubview:self.myCaiBtn];
        
    }
    return self;
}



- (void)configVegHeader:(NSMutableArray *)data
{
        self.focusView.hidden = NO;
        self.topImageView.hidden = YES;
        [_focusView stopAutoRun];
        [_slideData removeAllObjects];
        [_slideData addObjectsFromArray:data];
        [_focusView reloadData];
        [_focusView startAutoRun];
}


#pragma mark - EWFocusViewDelegate & Datasource
- (UIView *)focusView:(EWFocusView *)focusView pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_slideData[index][@"photo"]] placeholderImage:[UIImage imageNamed:@"banner"]];
    return imageView;
}

- (NSString *)focusView:(EWFocusView *)focusView titleForPageAtIndex:(NSInteger)index
{
    
    return _slideData[index][@"name"];
}

- (NSInteger)numberOfPages:(EWFocusView *)focusView
{
    return  _slideData.count;
}


- (void)focusView:(EWFocusView *)focusView didSelectAtIndex:(NSInteger)index
{
    
    if ([_delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [_delegate didSelectItemAtIndex:index];
    }
}

- (void)stopTimer
{
    [self.focusView stopAutoRun];
}


#pragma mark - Getter
- (EWFocusView *)focusView
{
    if (!_focusView) {
        _focusView = [[EWFocusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216/2.0+64+40) showPageIndicator:NO];
        _focusView.delegate = self;
        _focusView.dataSource = self;
        _focusView.timeInterval = 5;
        _focusView.hidden = YES;
        
    }
    return _focusView;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.image = [UIImage imageNamed:@"top"];
        _topImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 216/2.0+64+40);
        _topImageView.hidden = YES;
    }
    return _topImageView;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = WHITE_COLOR;
        _bottomView.frame = CGRectMake(0, 216/2.0+64+20, SCREEN_WIDTH, 266/2.0+10);
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FONT(16);
    }
    return _titleLabel;
}

- (UIButton *)allCaiBtn
{
    if (!_allCaiBtn) {
        _allCaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allCaiBtn.adjustsImageWhenHighlighted = NO;
        _allCaiBtn.titleLabel.numberOfLines = 0;
        _allCaiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_allCaiBtn setTitleColor:RGB_COLOR(50, 189, 111) forState:UIControlStateNormal];
        _allCaiBtn.titleLabel.font = FONT(12);
        _allCaiBtn.frame = CGRectMake(0, 31, SCREEN_WIDTH, 102+10);

    }
    return _allCaiBtn;
}

- (UIButton *)myCaiBtn
{
    if (!_myCaiBtn) {
        _myCaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myCaiBtn.adjustsImageWhenHighlighted = NO;
    }
    return _myCaiBtn;
}


@end
