//
//  VGModel.h
//  Garden
//
//  Created by 金学利 on 8/1/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface VGModel : NSObject
@property (nonatomic, assign) NSInteger errcode;
@property (nonatomic, strong) NSString *errmsg;
@end



@interface ZoneInfo : NSObject
@property (nonatomic, assign) NSInteger zid;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, strong) NSString *bgimg;
@property (nonatomic, assign) double dist;
@end


@interface ZoneList : VGModel
@property (nonatomic, strong) NSArray *zones;
@end

@interface RegionInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, assign) BOOL isleaf;
@end


@interface Regions : VGModel
@property (nonatomic, strong) NSArray *regions;
@end


/**
 *  Home
 */

@interface CombosInfo : NSObject
@property (nonatomic ,assign) NSInteger cid;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *mprices;
@property (nonatomic, strong) NSArray *weights;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSArray *tiles;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSArray *shipday;
@property (nonatomic, assign) NSInteger issue_no;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSArray *wimgs;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, assign) NSInteger fid;


@property (nonatomic, assign) BOOL choose;
@property (nonatomic, assign) double orderno; // 如果是我的套餐 修改传这个
@property (nonatomic, assign) double con; //如果是我的套餐 选菜传这个
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDictionary *chgtime;

//2.2.0新增的
@property (nonatomic, assign) NSInteger reason;
//1.本周已选菜（status=1时，可以变更菜品/cai/altorder），2.已过选菜日，3.已延期配送
@property (nonatomic, assign) NSInteger times; // 次数
//times + 1 == duration * shipday.length判断是不是该最后一次选菜了；
@property (nonatomic, strong) NSArray *addon; //// 最近一次选菜的套餐固定菜品




- (NSString *)weekTimesAndWeight;
- (NSString *)monthAndWeight;
- (NSString *)totalPrice;
- (NSString *)oriPrice;
- (NSString *)photo;
- (NSString *)name;

@end

@interface HomeData : VGModel
@property (nonatomic, strong) NSArray *mycombos;
@property (nonatomic, strong) NSArray *combos;
@end



/**
 *  套餐详情
 */

@interface ComboItemInfo : NSObject
@property (nonatomic, assign) CGFloat quantity;
@property (nonatomic, assign) NSInteger itemid;
@property (nonatomic, assign) NSInteger combo_id;
@property (nonatomic, assign) NSInteger freq;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double create;
@property (nonatomic, assign) NSInteger iid;
//@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *unit;

//2.2.0 取代原来img && 新增
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger remains;// 剩余次数
@property (nonatomic, assign) NSInteger ciid; // 为了统一用这个类，这个是 comboitemlist 返回的都有的

@end

@interface ComboDetail : VGModel
@property (nonatomic, strong) CombosInfo *combo;
@property (nonatomic, strong) NSArray *combo_items;
@end

/**
 *  菜品列表
 */
@interface VGItemInfo : NSObject
@property (nonatomic, assign) NSInteger maxpacks;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger remains;
@property (nonatomic, assign) NSInteger issue_no;
@property (nonatomic, assign) NSInteger packw;
@property (nonatomic, assign) NSInteger combo_id;
@property (nonatomic, assign) NSInteger vid;
@property (nonatomic, assign) NSInteger iid;
@property (nonatomic, strong) NSString *title;
@end

@interface VGList : VGModel
@property (nonatomic, strong) NSArray *items;
@end


/**
 *  轮播图
 */


@interface LinkInfo : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger lid;
@end

@interface SlideInfo : NSObject
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *link; //扩展
@end

@interface SlideData : VGModel
@property (nonatomic, strong) NSArray *slides;
@end


/**
 *  地址
 */

@interface AddressInfo : NSObject
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger adefault;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *zname;

@property (nonatomic, strong) NSString *doneAddress;

@end

@interface AddressList : VGModel
@property (nonatomic, strong) NSArray *addresses;
@end


/**
 *  订单相关
 */

typedef NS_ENUM(NSInteger, OrderStatus)
{
    OrderStatus_NotPay = 0,
    OrderStatus_NotSent,
    OrderStatus_Senting,
    OrderStatus_Done,
    OrderStatus_Cancel,
    OrderStatus_ComboDone,
};


typedef NS_ENUM(NSInteger, OrderType)
{
    //1.套餐订单 2.选菜订单, 3.单品订单, 4.自动选菜订单
    OrderType_Combo = 1,
    OrderType_Choose,
    OrderType_Signal,
    OrderType_Auto,
};



@interface OrderInfo : NSObject
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger combo_idx;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, assign) BOOL cod;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger issue_no;
@property (nonatomic, assign) NSInteger combo_id;
@property (nonatomic, assign) double orderno;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSDictionary *chgtime;

//新增的
@property (nonatomic, assign) double con;
@property (nonatomic, assign) NSInteger item_type;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, assign) NSInteger paytype;

//2.2.0 新增
@property (nonatomic, strong) NSArray *addon;


- (NSString *)orderStatus;
- (NSString *)sentDate;
- (UIColor *)orderStatusColor;

@end


@interface OrderList : VGModel
@property (nonatomic, strong) NSArray *orders;
@end



/**
 *  推荐商品
 */

@interface RecommendGoodsInfo: NSObject
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, assign) NSInteger iid ;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger maxpacks;
@property (nonatomic, assign) NSInteger packw;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) NSInteger remains;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL bought;
@end

@interface RecommendGoodsData : VGModel
@property (nonatomic, strong) NSArray *items;
@end

/**
 *  订单详情
 */
@interface OrderDetail : NSObject
@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) double orderno;
@property (nonatomic, assign) NSInteger packs;
@property (nonatomic, assign) NSInteger packw;
@property (nonatomic, strong) NSString *title;
@end

@interface SparesDetail : NSObject
@property (nonatomic, assign) double created;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) double modified;
@property (nonatomic, assign) double orderno;
@property (nonatomic, assign) NSInteger siid;
@property (nonatomic, strong) NSString *title;
@end

@interface OrderDetailItemList : VGModel
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *spares;
@property (nonatomic, assign) BOOL cpflag;
@end


/**
 *  新的首页信息
 */

@interface TCDesc : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *storage;
@property (nonatomic, strong) NSString *image;
@end

@interface TCData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger type; //1普通 2秒杀
@property (nonatomic, assign) BOOL bought;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float packw;
@property (nonatomic, assign) NSInteger iid;
@property (nonatomic, assign) NSInteger maxpacks;
@property (nonatomic, assign) NSInteger remains;
@property (nonatomic, assign) NSInteger mprice;
@property (nonatomic, assign) NSInteger sales;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, strong) TCDesc *detail;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, assign) NSInteger fid;

- (NSString *)tcPhoto;
- (NSString *)tcTitle;
- (NSString *)tcCount;
- (NSString *)tcper;
- (NSAttributedString *)tcPrice;

@end

@interface CaiHomeData : VGModel
//@property (nonatomic, strong) CombosInfo *mycombo;
@property (nonatomic, assign) BOOL has_combo;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *slides;
@end


//红包
//详情没有列出来

@interface CouponsData : NSObject
@property (nonatomic, assign) NSInteger charge;
@property (nonatomic, assign) NSInteger cpid;
@property (nonatomic, assign) double created;
@property (nonatomic, assign) NSInteger discount;
@property (nonatomic, assign) NSInteger distype;
@property (nonatomic, assign) double expire;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger used;

@end

@interface CaiCoupon : VGModel
@property (nonatomic, strong) NSArray *coupons;
@end


@interface UserAddressInfo : NSObject
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *address; //new
@property (nonatomic, assign) BOOL adefault;

@property (nonatomic, strong) NSString *doneAddress;

//以下废弃了
//@property (nonatomic, assign) NSInteger zid;
//@property (nonatomic, strong) NSString *zname;
//@property (nonatomic, strong) NSString *bur;

@end

@interface UserAddress : VGModel
@property (nonatomic, strong) NSArray *addresses;
@end


@interface ShareData : VGModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger count;
@end


@interface TCMore : VGModel
@property (nonatomic, strong) NSArray *items;
@end


//新增

@interface UserOrderInfo:NSObject
@property (nonatomic, strong) NSDictionary *chgtime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double con;
@property (nonatomic, assign) NSInteger status;

//2.2.0 新增,
@property (nonatomic, assign) NSInteger duration;//24  // 套餐配送时长，单位：周
@property (nonatomic, strong) NSArray *shipday;
@property (nonatomic, assign) BOOL chooseday;
@end

@interface UserCombos : VGModel
@property (nonatomic, strong) NSArray *combo_orders;
@end



//延期

@interface Delay : NSObject
@property (nonatomic, assign) double date;
@property (nonatomic, assign) NSInteger times;
@end

@interface DelayInfo : NSObject
@property (nonatomic, assign) double orderno;
@property (nonatomic, assign) NSInteger combo_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Delay *delay;
@property (nonatomic, assign) NSInteger status; //// 0.没有选菜，可以延期；1.已经延期，不能再延期；2.已选过菜，不能延期
@end

@interface DelayData : VGModel
@property (nonatomic, strong) NSArray *data;
@end


//2.2.0
@interface ComboItemList : VGModel
@property (nonatomic, strong) NSArray *items;
@end


//2.2.0
@interface AddonInfo : NSObject
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *unit;
@end


//2.2.0 orderinfo  v2
@interface OrderDetailV2 : VGModel
@property (nonatomic, assign) BOOL cpflag;
@property (nonatomic, strong) NSArray *data;
@end

@interface OrderInfoV2 : NSObject
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray *spares;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *chgtime;
@end


@interface ItemInfo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) NSInteger packw;
@property (nonatomic, assign) NSInteger packs;
@end
