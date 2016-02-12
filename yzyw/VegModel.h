//
//  VegModel.h
//  Lynp
//
//  Created by nmg on 16/1/16.
//  Copyright © 2016年 nmg. All rights reserved.
//

#ifndef VegModel_h
#define VegModel_h

//@interface BaseModel : NSObject
//    @property (nonatomic, assign) NSInteger errcode;
//    @property (nonatomic, strong) NSString *errmsg;
//@end

@interface VegCellData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float mprice;
@property (nonatomic, assign) float size;


- (NSString *)photo;
- (NSString *)name;
- (NSString *)desc;
- (float)size;
- (float)price;
- (float)mprice;

@end


@interface VegData : NSObject
    @property (nonatomic, strong) NSArray *items;
    @property (nonatomic, strong) NSArray *slides;

    @property (nonatomic, assign) NSInteger errcode;
    @property (nonatomic, strong) NSString *errmsg;
@end

#endif /* VegModel_h */
