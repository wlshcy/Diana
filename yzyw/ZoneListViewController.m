//
//  ZoneListViewController.m
//  Lynp
//
//  Created by nmg on 16/2/6.
//  Copyright © 2016年 nmg. All rights reserved.
//

#define WIDTH  self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

#import "ZoneListViewController.h"
#import "YMUtils.h"


@interface ZoneListViewController ()

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation ZoneListViewController
{
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
    NSInteger row4;
}
- (instancetype)init
{
    if (self = [super init]) {
            [self layoutNavigationBar];
    }
//    [self getZoneData];
    
    return self;
}

//- (void) getZoneData
//{
//    [HTTPManager getZoneData:^(NSMutableArray *response) {
//        
////        _listData = response;
////        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData: response options:NSJSONReadingMutableContainers error:nil];
////        [_listData addObjectsFromArray:array];
//        _listData = [NSKeyedUnarchiver unarchiveObjectWithData:response];
//        
//    } failure:^(NSError *err) {
//        
//    }];
//
//}
- (void)layoutNavigationBar
{
    self.title = @"区域选择";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
//        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BLACK_COLOR,NSFontAttributeName:FONT(14)} forState:UIControlStateNormal];
}

- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    row1 = 0;
    row2 = 0;
    row3 = 0;
    row4 = 0;
    
    self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-60)];
    self.cityPicker.tag = 0;
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    self.cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview:self.cityPicker];
    self.cityPicker.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.saveBtn];
    
}

//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.cityPicker) {
        return 4;
    }
    else
        return 1;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return [YMUtils getCityData].count;
     }
    else if (component == 1) {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            return array.count;
        }
        return 0;
       
    }
    else if (component == 2) {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            NSArray *array1 = [YMUtils getCityData][row1][@"children"][row2][@"children"];
            if ((NSNull*)array1 != [NSNull null]) {
                return array1.count;
            }
            return 0;
        }
        return 0;
        
    }
    else  {
        NSArray *array = [YMUtils getCityData][row1][@"children"][row2][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            NSArray *array1 = [YMUtils getCityData][row1][@"children"][row2][@"children"][row3][@"children"];
            if ((NSNull*)array1 != [NSNull null]) {
                return array1.count;
            }
            return 0;
        }
        return 0;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0) {
        return [YMUtils getCityData][row][@"name"];
      }
    else if (component == 1) {
        return [YMUtils getCityData][row1][@"children"][row][@"name"];
    
    }
    else if (component == 2) {
        return [YMUtils getCityData][row1][@"children"][row2][@"children"][row][@"name"];
    }
    else {
        return [YMUtils getCityData][row1][@"children"][row2][@"children"][row3][@"children"][row][@"name"];
        
    }
    
    return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        row1 = row;
        row2 = 0;
        row3 = 0;
        row4 = 0;
        
        [self.cityPicker reloadComponent:1];
        [self.cityPicker reloadComponent:2];
        [self.cityPicker reloadComponent:3];
    }
    else if (component == 1){
        row2 = row;
        row3 = 0;
        row4 = 0;
        
        [self.cityPicker reloadComponent:2];
        [self.cityPicker reloadComponent:3];
        
    }
    else if (component == 2){
        row3 = row;
        row4 = 0;
        [self.cityPicker reloadComponent:3];
    }
    else {
        row3 = row;
    }
//    NSInteger cityRow1 = [self.cityPicker selectedRowInComponent:0];
//    NSInteger cityRow2 = [self.cityPicker selectedRowInComponent:1];
//    NSInteger cityRow3 = [self.cityPicker selectedRowInComponent:2];
//    NSInteger cityRow4 = [self.cityPicker selectedRowInComponent:3];
//    
//    NSMutableString *str = [[NSMutableString alloc]init];
//    [str appendString:[YMUtils getCityData][cityRow1][@"name"]];
//    NSArray *array = [YMUtils getCityData][cityRow1][@"children"];
//    if ((NSNull*)array != [NSNull null]) {
//        [str appendString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"name"]];
//        NSArray *array1 = [YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"];
//        if ((NSNull*)array1 != [NSNull null]) {
//            [str appendString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"][cityRow3][@"name"]];
//        }
//    }
//    
//    self.cityLabel.text = str;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        titleLabel.text = [YMUtils getCityData][row][@"name"];
    }
    else if (component == 1) {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row][@"name"];
    }
    else if (component == 2) {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row2][@"children"][row][@"name"];
    }
    else {
        titleLabel.text = [YMUtils getCityData][0][@"children"][0][@"children"][0][@"children"][row][@"name"];
    }
    
    return titleLabel;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _saveBtn.backgroundColor = WHITE_COLOR;
        [_saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:RGB_COLOR(17, 194, 88) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = FONT(16);
        [_saveBtn addTarget:self action:@selector(saveZone:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.adjustsImageWhenHighlighted = YES;
    }
    return _saveBtn;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60)];
        _footerView.backgroundColor = CLEAR_COLOR;
    }
    return _footerView;
}

- (void)saveZone:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewController:didPassingValueWithInfo:)]){
            NSInteger Row1 = [self.cityPicker selectedRowInComponent:0];
            NSInteger Row2 = [self.cityPicker selectedRowInComponent:1];
            NSInteger Row3 = [self.cityPicker selectedRowInComponent:2];
            NSInteger Row4 = [self.cityPicker selectedRowInComponent:3];
        
            NSMutableString *str = [[NSMutableString alloc]init];
            [str appendString:[YMUtils getCityData][Row1][@"name"]];
            NSArray *array = [YMUtils getCityData][Row1][@"children"];
            if ((NSNull*)array != [NSNull null]) {
                [str appendString:[YMUtils getCityData][Row1][@"children"][Row2][@"name"]];
                NSArray *array1 = [YMUtils getCityData][Row1][@"children"][Row2][@"children"];
                if ((NSNull*)array1 != [NSNull null]) {
                    [str appendString:[YMUtils getCityData][Row1][@"children"][Row2][@"children"][Row3][@"name"]];
                    NSArray *array2 = [YMUtils getCityData][Row1][@"children"][Row2][@"children"][Row3][@"children"];
                    if ((NSNull*)array2 != [NSNull null]) {
                        [str appendString:[YMUtils getCityData][Row1][@"children"][Row2][@"children"][Row3][@"children"][Row4][@"name"]];
                    }
                }
            }

        [self.delegate viewController:self didPassingValueWithInfo:str];
    }
    
}
@end
