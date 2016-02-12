//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //[self addSubview:_indexLabel];
    }
    
    // 保存图片按钮/Users/Kingxl/Downloads/图片浏览器示例/图片浏览器示例/lib/MJPhotoBrowser/MJPhotoToolbar.h
    CGFloat btnheight = self.bounds.size.height;
    CGFloat btnwidth = self.bounds.size.width;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.frame = CGRectMake(0, 0, btnwidth, btnheight);
//    _saveImageBtn.backgroundColor = YELLOW_COLOR;
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"download_img_1"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"download_img_2"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    [self bringSubviewToFront:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%@/ %@", @(_currentPhotoIndex + 1), @(_photos.count)];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    //_saveImageBtn.enabled = photo.image != nil && !photo.save;
    if (photo.save) {
        _saveImageBtn.enabled = NO;
    }else{
        _saveImageBtn.enabled = YES;
    }
}

@end
