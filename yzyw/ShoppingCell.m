//
//  ShoppingCell.m
//  Garden
//
//  Created by nmg on 16/2/2.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "ShoppingCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ShoppingCell ()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSDictionary  *shopdata; //具体看model 还没赋值

@end

@implementation ShoppingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WHITE_COLOR;
        [self addSubview:self.photo];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.subBtn];
        [self addSubview:self.countLabel];
        [self addSubview:self.addBtn];

    }
    return self;
}


- (void)configCellData:(NSDictionary *)data
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:data[@"photo"]] placeholderImage:[UIImage imageNamed:@"home_rec"]];
    self.nameLabel.text = data[@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[data[@"price"] floatValue]];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@",data[@"count"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.photo.frame = CGRectMake(20, 10, 100, 90);
    self.nameLabel.frame = CGRectMake(self.photo.right+20, self.photo.top+5, 150, 20);
//    self.priceLabel.frame = CGRectMake(self.photo.right+20, self.nameLabel.bottom+35, 150, 20);
//    
//    self.addBtn.frame = CGRectMake(self.width-50, self.nameLabel.bottom+25, 35, 35);
//    self.countLabel.frame = CGRectMake(self.addBtn.left-35, self.addBtn.top, 35, 35);
//    self.subBtn.frame = CGRectMake(self.countLabel.left-35, self.nameLabel.bottom+25, 35, 35);
    self.priceLabel.frame = CGRectMake(self.photo.right+20, self.nameLabel.bottom+10, 150, 20);
    self.subBtn.frame = CGRectMake(self.photo.right+20, self.priceLabel.bottom+5, 35, 35);
    self.countLabel.frame = CGRectMake(self.subBtn.right, self.priceLabel.bottom+5, 30, 35);
    self.addBtn.frame = CGRectMake(self.countLabel.right, self.priceLabel.bottom+5, 35, 35);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - getter & setter
- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
        _photo.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        [_photo addGestureRecognizer:tap];

    }
    return _photo;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT(16);
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = CLEAR_COLOR;
    }
    
    return _nameLabel;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = FONT(16);
        _priceLabel.textColor = RGB_COLOR(50, 189, 111);
        _priceLabel.backgroundColor = CLEAR_COLOR;
    }
    
    return _priceLabel;
    
}

- (UIButton *)subBtn
{
    if (!_subBtn) {
        _subBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_subBtn setImage:[UIImage imageNamed:@"detail_sub"] forState:UIControlStateNormal];
    }
    return _subBtn;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
         _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, self.nameLabel.bottom+50, SCREEN_WIDTH-32, 20)];
//        _addBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_addBtn setImage:[UIImage imageNamed:@"detail_add"] forState:UIControlStateNormal];
    }
    return _addBtn;
}


- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.font = FONT(16);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}


- (void)showImage:(UITapGestureRecognizer *)tap
{
    
    
    NSArray *images = [(TCData *)_shopdata[@"data"] imgs];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < images.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:images[i]]; // 图片路径
        photo.srcImageView = _photo;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}


@end
