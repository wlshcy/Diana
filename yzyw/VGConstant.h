//
//  VGConstant.h
//  Garden
//
//  Created by 金学利 on 8/1/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#ifndef Garden_VGConstant_h
#define Garden_VGConstant_h


#define SHOULDINIT @"init"
#define XSRF @"_xsrf"
#define XSRFVALUE [EWUtils getObjectForKey:XSRF]


#pragma mark - useragent
#define USERHASLOGIN  @"youcailogin"

#define USERADDRESS  @"address"
#define USERMOBILE   @"mobile"
#define USERHEADIMG  @"headimg"
#define USERID       @"id"
#define USERNAME     @"name"

//test
#define NET_TIPS @"亲，没网了!"

#define TABLE_COLOR RGB_COLOR(242, 242, 242)


#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate


#define UMENG_KEY @"55d68f24e0f55a53bd0013c7"
#define WXKEY @"wxedddf5c468bfd955"
#define WXSEC @"ea6ca4bab29d7243bfa97a7f46a930a7"

#define ScaleX (SCREEN_HEIGHT>480?SCREEN_WIDTH/320:1.0)
#define ScaleY (SCREEN_HEIGHT>480?SCREEN_HEIGHT/568:1.0)

#define CGRectScaleXY(X,Y,W,H) CGRectMake(X*ScaleX,Y*ScaleY,W*ScaleX+4,H*ScaleY+2)
#define MaxX(A) (CGRectGetMaxX(A))
#define MaxY(A) (CGRectGetMaxY(A))
#define MinX(A) (CGRectGetMinX(A))
#define MinY(A) (CGRectGetMinY(A))

#endif
