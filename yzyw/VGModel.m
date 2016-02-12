//
//  VGModel.m
//  Garden
//
//  Created by 金学利 on 8/1/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "VGModel.h"

@implementation VGModel
@end

@implementation ZoneInfo
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"zid":@"id"};
}

@end

@implementation ZoneList
+ (NSDictionary *)objectClassInArray
{
    return @{@"zones":[ZoneInfo class]};
}
@end

@implementation RegionInfo
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"rid":@"id"};
}
@end

@implementation Regions

+ (NSDictionary *)objectClassInArray
{
    return @{@"regions":[RegionInfo class]};
}

@end


@implementation CombosInfo
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid":@"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"addon":[AddonInfo class]};
}


//method
- (NSString *)weekTimesAndWeight
{
    return [NSString stringWithFormat:@"共%@次 | %d斤/次 | %@次/周",@(_duration*_shipday.count),[ _weights[_index] intValue]/500,@([_shipday count])];
    //return [NSString stringWithFormat:@"%@次/周  %d斤/次",@([_shipday count]),[ _weights[_index] intValue]/500];
}

- (NSString *)monthAndWeight
{
    
    return [NSString stringWithFormat:@"来自:%@",self.farm];
//    NSString *week = [NSString stringWithFormat:@"%@",@(_duration)];
//    int total = (int)_duration * [(NSNumber *)_weights[_index] intValue] * (int)_shipday.count/500;
//    
//    return [NSString stringWithFormat:@"送%@周   共%d斤",week,total];
}

- (NSString *)totalPrice
{
    return [NSString stringWithFormat:@"￥%0.2f",[_prices[_index] floatValue]/100.0];
}

- (NSString *)oriPrice
{
    return[NSString stringWithFormat:@"￥%0.2f",[_mprices[_index] floatValue]/100.0];
}


- (NSString *)photo
{
    return _img;
}

- (NSString *)name
{
    return _title;
}

@end


@implementation HomeData

+ (NSDictionary *)objectClassInArray
{
    return @{@"combos":[CombosInfo class],@"mycombos":[CombosInfo class]};
}

@end



@implementation ComboItemInfo
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"itemid":@"id"};
}
@end


@implementation ComboDetail

+ (NSDictionary *)objectClassInArray
{
    return @{@"combo_items":[ComboItemInfo class]};
}

@end


@implementation VGItemInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"vid":@"id"};
}

@end

@implementation VGList

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[VGItemInfo class]};
}

@end

@implementation LinkInfo
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"lid":@"id"};
}

@end

@implementation SlideInfo
@end

@implementation SlideData
+ (NSDictionary *)objectClassInArray
{
    return @{@"slides":[SlideInfo class]};
}
@end


@implementation AddressInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"aid":@"id",@"adefault":@"default"};
}
@end


@implementation AddressList

+ (NSDictionary *)objectClassInArray
{
    return @{@"addresses":[AddressInfo class]};
}

@end

/**
 *  order
 */

@implementation OrderInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"oid":@"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"addon":[AddonInfo class]};
}


- (NSString *)orderStatus
{
    if(self.status ==  OrderStatus_NotPay) {
        return @"未付款";
    }else if (self.status == OrderStatus_NotSent){
        return @"未配送";
    }else if (self.status == OrderStatus_Senting){
        return @"配送中";
    }else if (self.status == OrderStatus_Done){
        return @"配送完成";
    }else{
        return @"取消订单";
    }
}

- (UIColor *)orderStatusColor
{
    if(self.status ==  OrderStatus_NotPay) {
        return RGB_COLOR(243, 96, 67);
    }else if (self.status == OrderStatus_NotSent){
        return RGB_COLOR(148,214,192);
    }else if (self.status == OrderStatus_Senting){
        return RGB_COLOR(148,214,192);
    }else if (self.status == OrderStatus_Done){
        return RGB_COLOR(209, 209, 209);
    }else{
        return RGB_COLOR(209, 209, 209);
    }

}

- (NSString *)sentDate
{
    
    double timeStamp =[self.chgtime[[NSString stringWithFormat:@"%@",@(self.status)]] doubleValue];
    
    if (self.status == OrderStatus_NotPay) {
        return [NSString stringWithFormat:@"下单日期:%@",[NSDate ew_formatTimeWithInterval:timeStamp]];
    }else if (self.status == OrderStatus_NotSent){
        return [NSString stringWithFormat:@"支付日期:%@",[NSDate ew_formatTimeWithInterval:timeStamp]];
    }else if (self.status == OrderStatus_Senting){
        return [NSString stringWithFormat:@"配送日期:%@",[NSDate ew_formatTimeWithInterval:timeStamp]];
    }else if (self.status == OrderStatus_Done){
        return [NSString stringWithFormat:@"收货日期:%@",[NSDate ew_formatTimeWithInterval:timeStamp]];
    }else{
        return @"";
    }
}

@end


@implementation OrderList

+ (NSDictionary *)objectClassInArray
{
    return @{@"orders":[OrderInfo class]};
}

@end

@implementation RecommendGoodsInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"rid":@"id"};
}

@end

@implementation RecommendGoodsData

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[RecommendGoodsInfo class]};
}


@end


@implementation OrderDetail

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"oid":@"id"};
}

@end

@implementation SparesDetail
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"sid":@"id"};
}
@end

@implementation OrderDetailItemList

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[OrderDetail class],@"spares":[SparesDetail class]};
}

@end


@implementation TCDesc
@end

@implementation TCData

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"tid":@"id"};
}


- (NSString *)tcPhoto
{
    return self.imgs.firstObject;
}

- (NSString *)tcTitle
{
    return self.title;
}

- (NSString *)tcCount
{
    return [NSString stringWithFormat:@"%.1f斤/份",self.packw/500.0];
}


- (NSString *)tcper
{
    return [NSString stringWithFormat:@"%@人选择",@(self.sales)];
}

- (NSAttributedString *)tcPrice
{
    
    if (self.mprice > 0) {
        NSString *priceText = [NSString stringWithFormat:@"￥%.2f  ￥%.2f",self.price/100.00,self.mprice/100.00];
        
        
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:priceText];
        
        NSRange range = [priceText rangeOfString:[NSString stringWithFormat:@"￥%.2f",self.mprice/100.00]];
        
        
        [content addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:RGB_COLOR(160, 160, 160),NSForegroundColorAttributeName:RGB_COLOR(160, 160, 160),NSFontAttributeName:FONT(12)} range:range];
        
        return content;

    }else{
        NSString *priceText = [NSString stringWithFormat:@"￥%.2f",self.price/100.00];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:priceText];
        return content;

    }
    
}



@end

@implementation CaiHomeData

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[TCData class],@"slides":[SlideInfo class]};
}
@end



@implementation CouponsData
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid":@"id"};
}


@end

@implementation CaiCoupon
+ (NSDictionary *)objectClassInArray
{
    return @{@"coupons":[CouponsData class]};
}
@end


@implementation UserAddressInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"aid":@"id",@"adefault":@"default"};
}


@end

@implementation UserAddress
+ (NSDictionary *)objectClassInArray
{
    return @{@"addresses":[UserAddressInfo class]};
}

@end


@implementation ShareData
@end

@implementation TCMore

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[TCData class]};
}


@end


//user
@implementation UserOrderInfo
@end

@implementation UserCombos
+ (NSDictionary *)objectClassInArray
{
    return @{@"combo_orders":[UserOrderInfo class]};
}
@end


@implementation Delay
@end

@implementation DelayInfo
@end

@implementation DelayData
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[DelayInfo class]};
}
@end

@implementation ComboItemList //ciid

+ (NSDictionary *)objectClassInArray
{
    return @{@"items":[ComboItemInfo class]};
}

@end

@implementation AddonInfo

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"aid":@"id"};
}
@end

@implementation OrderDetailV2

+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[OrderInfoV2 class]};
}

@end

@implementation OrderInfoV2
+ (NSDictionary *)objectClassInArray
{
    return @{@"spares":[SparesDetail class],@"items":[ItemInfo class]};
}
@end

@implementation ItemInfo

@end

