//
//  EWLocationManager.m
//  MyVillage
//
//  Created by 金学利 on 6/11/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "EWLocationManager.h"

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;


@interface EWLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *location;
@property (nonatomic, copy) LocationSuccessBlock success;
@property (nonatomic, copy) LocationErrorBlock error;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) NSInteger count;
@end

@implementation EWLocationManager

+ (instancetype)instance
{
    static EWLocationManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[EWLocationManager alloc] init];
    });
    return manger;
}

- (id)init
{
    if (self = [super init]) {
        
        _location = [[CLLocationManager alloc] init];
        _location.delegate = self;
        [_location setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([_location respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_location requestAlwaysAuthorization];
            [_location requestWhenInUseAuthorization];
        }
        // [location startUpdatingLocation];
        
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    DBLog(@"location=%@",@([newLocation coordinate].latitude));
    
    if (_count == 2) {
        if (_flag) {
            [_location stopUpdatingLocation];
            CLLocationCoordinate2D loc = [newLocation coordinate];
            CLLocationCoordinate2D coord = [self transformFromWGSToGCJ:loc];
            _success(coord);
            _flag = NO;
            
        }
    }else{
        _count ++;
    }
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DBLog(@"error =%@",error.localizedDescription);
    if (_flag) {
        _error(error);
        _flag = NO;
    }
    
    [_location stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        if (_flag) {
            _error(nil);
            _flag = NO;
        }
        
        [_location stopUpdatingLocation];
        
    }
}



- (void)getLocationCoordinate:(LocationSuccessBlock)success error:(LocationErrorBlock)error
{
    _success = [success copy];
    _error = [error copy];
    _flag = YES;
    _count = 0;
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){

        [_location startUpdatingLocation];

    }else{
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        _error(nil);
    }
}

- (void)stopLocation{
    
    [_location stopUpdatingLocation];
    
}


-(double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}


-(double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

- (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    CLLocationCoordinate2D adjustLoc;
    if([self isLocationOutOfChina:wgsLoc]){
        adjustLoc = wgsLoc;
    }else{
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double radLat = wgsLoc.latitude / 180.0 * pi;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat;
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}

-(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

- (CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)gcLoc
{
    double x = gcLoc.longitude, y = gcLoc.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake( z * sin(theta) + 0.006,z * cos(theta) + 0.0065);
}

@end
