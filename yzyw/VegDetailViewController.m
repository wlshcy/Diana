//
//  VegDetailViewController.m
//  Garden
//
//  Created by nmg on 9/9/15.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import "VegDetailViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "LoginViewController.h"
#import "CrossLineLabel.h"


@interface VegDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (nonatomic, strong)NSDictionary *item;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;
//@property (nonatomic, strong) UIButton *shareBtn;


@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *carBtn;
//@property (nonatomic, strong) UIButton *toBtn;

@property (nonatomic, assign) NSInteger count; //选择的数量；


@property (nonatomic, strong) UITableView *listView;
//@property (nonatomic, strong) UIScrollView *headerView;
@property (nonatomic, strong) UIImageView *headerView;

//@property (nonatomic, strong) UIView *footView;
//@property (nonatomic, strong) UILabel *contentLabel;


//
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) CrossLineLabel *mpriceLabel;
//@property (nonatomic, strong) UILabel *cLabel;
@property (nonatomic, strong) UIImageView *cImageView;

@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;


@end

@implementation VegDetailViewController

//- (instancetype)initWithData:data
- (instancetype)init
{
    if (self = [super init]) {
        _count = 1;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WHITE_COLOR;

    
    if (_item) {
        [self configView];
    }else{
        [self getVegDetail];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configView
{
    
    [self.view addSubview:self.listView];
    self.listView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
//    [self.topView addSubview:self.shareBtn];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.subBtn];
    [self.bottomView addSubview:self.countLabel];
    [self.bottomView addSubview:self.addBtn];
    [self.bottomView addSubview:self.carBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
//    if (section ==0) {
//        return 1;
//    }else if (section == 1){
//        return 3;
//    }else{
//        return 1;
//    }
    if (section == 0){
        return 1;
    }
    return 2;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,6)];
    view.backgroundColor = RGB_COLOR(242, 242, 242);
    return view;
}


//计算一下第一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 196/2.0 ;
    }else if (indexPath.section == 1){
        return 43+7;
    }else{
        return 43+20;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"aaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell addSubview:self.titleLabel];
        [cell addSubview:self.subTitleLabel];
        [cell addSubview:self.priceLabel];
//        [cell addSubview:self.mpriceLabel];
        
        return cell;
    }
    else {
        static NSString *cellIndentifier = @"bbCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        
        [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        if (indexPath.row == 0) {
//            cell.textLabel.text = [NSString stringWithFormat:@"规格: %@g/份",@((NSInteger)_tcdata.packw)];
            cell.textLabel.text = @"规格";
            cell.textLabel.font = FONT(16);
            cell.detailTextLabel.text=@"500g/份";
            cell.detailTextLabel.textColor = RGB_COLOR(0, 0, 0);
            cell.detailTextLabel.font = FONT(16);
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if(indexPath.row == 1){
            
//            NSString *storage = (_tcdata.detail.storage == nil)?@"":_tcdata.detail.storage;
            NSString *origin = @"民乐";
//            cell.textLabel.text = [NSString stringWithFormat:@"产地: %@",origin];
            cell.textLabel.text = @"产地";
            cell.textLabel.font = FONT(16);
            cell.detailTextLabel.text = origin;
            cell.detailTextLabel.textColor = RGB_COLOR(0, 0, 0);
            cell.detailTextLabel.font = FONT(16);
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        FarmDetailViewController *controller = [[FarmDetailViewController alloc] initWithFarmId:_tcdata];
//        
//        [self.navigationController pushViewController:controller animated:YES];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    DBLog(@"--------y===%@",@(scrollView.contentOffset.y));
    
    if (scrollView.contentOffset.y < -80) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        
    }
}


#pragma mark - Fetch data
- (void)getVegDetail
{
    [self showLoading];
    
    [HTTPManager showVeg:self.vid success:^(NSDictionary *response) {
        DBLog(@"%@",response);
    
        [self hideLoading];
        
        _item = response;
        [self.view addSubview:self.topView];
        [self.topView addSubview:self.backBtn];
//        [self.topView addSubview:self.shareBtn];
        
        [self configView];

        
    } failure:^(NSError *err) {
        [self hideLoading];
        [self showFailureStatusWithTitle:NET_TIPS];
        [self.view addSubview:self.topView];
        [self.topView addSubview:self.backBtn];
//        [self.topView addSubview:self.shareBtn];

    }];
}


#pragma mark - UserAction
- (void)closePage:(UIButton *)sender
{
    DBLog(@"-----count====%@",@(self.navigationController.viewControllers.count));
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)subTCGoods:(UIButton *)sender
{
    if (_count == 0) {
        return;
    }
    
    _count --;
    
    [self changeCountLabel];
    
    //[[DBManager instance] updateItem:_tcdata count:_count];
}

- (void)addTCGoods:(UIButton *)sender
{
    _count ++;
    _countLabel.text = [NSString stringWithFormat:@"%@",@(_count)];

}


- (void)showSharePage:(UIButton *)sender
{
    
//    NSString *url = [NSString stringWithFormat:@"https://youcai.shequcun.com/?state=recomitem/%@",@(_tcdata.tid)];
//    
//    [UMSocialWechatHandler setWXAppId:WXKEY appSecret:WXSEC url:url];
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = _tcdata.title;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _tcdata.title;
//    
//    [[ShareView instance] showInView:self.view blk:^(NSInteger index) {
//        
//        NSString *type ;
//        if (index == 0) {
//            DBLog(@"微信好友");
//            type = UMShareToWechatSession;
//        }else{
//            DBLog(@"朋友圈");
//            type = UMShareToWechatTimeline;
//        }
//        
//        UMSocialUrlResource *resource = [UMSocialUrlResource new];
//        resource.resourceType = UMSocialUrlResourceTypeImage;
//        resource.url = _tcdata.imgs.firstObject;
//        
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_tcdata.descr image:nil location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *response){
//            
//            DBLog(@"response==%@",response);
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                
////                [self showSuccessStatusWithTitle:@"分享成功"];
//            }
//        }];
//
//    
//    }];

}


- (void)addShopCar:(UIButton *)sender
{
    if(_count == 0){
        return;
    }
    [[DBManager instance] deleteItem:_item];
    [[DBManager instance] saveItem:_item count:_count];
    [self showSuccessStatusWithTitle:@"成功加入购物车"];

}

- (void)toShopCar:(UIButton *)sender
{
    DBLog(@"----hello world!!!");
    
    [[APPDELEGATE tabbarController] setSelectedIndex:1];

    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
    
        [self.navigationController dismissViewControllerAnimated:NO completion:^{

        }];
    }
    
    
}


#pragma mark - topView
- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return _topView;
}

-(UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(10, 20, 36,36);
//        _backBtn.layer.cornerRadius = 18;
//        _backBtn.backgroundColor = RGB_COLOR(0,0,0);
        [_backBtn setImage:[UIImage imageNamed:@"detail_close"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

//-(UIButton *)shareBtn
//{
//    if (!_shareBtn) {
//        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _shareBtn.frame = CGRectMake(SCREEN_WIDTH-10-44, 20, 36,36);
//        _shareBtn.layer.cornerRadius = 18;
//        _shareBtn.backgroundColor = RGB_COLOR(51,51,51);
//        [_shareBtn setImage:[UIImage imageNamed:@"detail_share"] forState:UIControlStateNormal];
//        [_shareBtn addTarget:self action:@selector(showSharePage:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shareBtn;
//}



- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 57);
    }
    return _bottomView;
}

#define BTNITEM 33
- (UIButton *)subBtn
{
    if (!_subBtn) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subBtn.frame = CGRectMake(20, (self.bottomView.height-BTNITEM)/2.0, BTNITEM, BTNITEM);
        [_subBtn setImage:[UIImage imageNamed:@"detail_sub"] forState:UIControlStateNormal];
        [_subBtn addTarget:self action:@selector(subTCGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subBtn;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subBtn.right, self.subBtn.top, 40, BTNITEM)];
        //_countLabel.backgroundColor = BLUE_COLOR;
        _countLabel.text = [NSString stringWithFormat:@"%@",@(_count)];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(self.countLabel.right, (self.bottomView.height-BTNITEM)/2.0, BTNITEM, BTNITEM);
        [_addBtn setImage:[UIImage imageNamed:@"detail_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addTCGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (UIButton *)carBtn
{
    if (!_carBtn) {
        _carBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        _carBtn.backgroundColor = RGB_COLOR(243, 95, 68);
        [_carBtn setTitleColor: WHITE_COLOR forState:UIControlStateNormal];
        _carBtn.titleLabel.font = FONT(14);
        _carBtn.layer.cornerRadius = 3;
        _carBtn.clipsToBounds = YES;
        [_carBtn addTarget:self action:@selector(addShopCar:) forControlEvents:UIControlEventTouchUpInside];
        [_carBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        _carBtn.frame = CGRectMake(SCREEN_WIDTH-20-170/2.0, (self.bottomView.height-76/2.0)/2.0, 170/2.0, 76/2.0);
    }
    return _carBtn;
}


//- (UIButton *)toBtn
//{
//    if (!_toBtn) {
//        _toBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _toBtn.frame = CGRectMake(SCREEN_WIDTH-5-170/2.0 , (self.bottomView.height-76/2.0)/2.0, 170/2.0, 76/2.0);
////        _toBtn.backgroundColor = RGB_COLOR(243, 96, 67);
//        [_toBtn setTitleColor: BLACK_COLOR forState:UIControlStateNormal];
//        _toBtn.titleLabel.font = FONT(14);
//        _toBtn.layer.cornerRadius = 3;
//        _toBtn.clipsToBounds = YES;
//        _toBtn.layer.borderColor = RGB_COLOR(204, 204, 204).CGColor;
//        _toBtn.layer.borderWidth = 1;
//        [_toBtn addTarget:self action:@selector(toShopCar:) forControlEvents:UIControlEventTouchUpInside];
//        [_toBtn setTitle:@"去购物车" forState:UIControlStateNormal];
//        
//    }
//    return _toBtn;
//
//}

- (void)changeCountLabel
{
    _countLabel.text = [NSString stringWithFormat:@"%@",@(_count)];

}


- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114/2.0) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = RGB_COLOR(242, 242, 242);
        _listView.tableFooterView = [UIView new];
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
    }
    return _listView;
}

//- (UIScrollView *)headerView
//{
//    if (!_headerView ) {
//        _headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 540/2.0)];
////        _headerView.contentSize = CGSizeMake(SCREEN_WIDTH*_tcdata.imgs.count, 540/2.0);
//        _headerView.contentSize = CGSizeMake(SCREEN_WIDTH, 540/2.0);
//
//        _headerView.pagingEnabled = YES;
//    
//        _headerView.showsHorizontalScrollIndicator = NO;
//        _headerView.showsVerticalScrollIndicator = NO;
//        
//        for (NSInteger i = 0 ; i < _tcdata.imgs.count; i++) {
//            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 540/2.0)];
//            [imageview sd_setImageWithURL:[NSURL URLWithString:_item[@"photo"]] placeholderImage:[UIImage imageNamed:@"goods_detail"]];
//            imageview.clipsToBounds = YES;
////            imageview.contentMode = UIViewContentModeScaleAspectFit;
//            [_headerView addSubview:imageview];
//        }
//    }
//    return _headerView;
//}

- (UIImageView *)headerView
{
    if (!_headerView ) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 540/2.0)];
        [_headerView sd_setImageWithURL:[NSURL URLWithString:_item[@"photo"]] placeholderImage:[UIImage imageNamed:@"goods_detail"]];
        _headerView.clipsToBounds = YES;
//        _headerView.contentMode = UIViewContentModeScaleAspectFit;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _headerView;
}

//- (UIView *)footView
//{
//    if (!_footView) {
//        _footView = [UIView new];
//        _footView.backgroundColor = WHITE_COLOR;
//        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
//        
//    }
//    
//    return _footView;
//}
//
//- (UILabel *)contentLabel
//{
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.text = _tcdata.detail.content;
//        _contentLabel.numberOfLines = 0;
//        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _contentLabel.font = FONT(15);
//        _contentLabel.textColor = RGB_COLOR(19, 19, 19);
//        
//        CGFloat textheight = [_tcdata.detail.content ew_heightWithFont:FONT(15) lineWidth:SCREEN_WIDTH-32];
//        _contentLabel.frame = CGRectMake(16, 13, SCREEN_WIDTH-32, textheight);
//    }
//    return _contentLabel;
//}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 250, 16)];
        title.text = _item[@"name"];
//        title.textAlignment=NSTextAlignmentCenter;
//        title.numberOfLines=1;
        title.font =FONT(16);
        _titleLabel = title;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        CGFloat height = [_item[@"desc"] ew_heightWithFont:FONT(14) lineWidth:SCREEN_WIDTH-32];
        
        
        UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.titleLabel.bottom+10, SCREEN_WIDTH-32, height)];
        subtitle.text = _item[@"desc"];
//        subtitle.textAlignment=NSTextAlignmentCenter;
//        subtitle.numberOfLines=1;
        subtitle.font =FONT(14);
        subtitle.textColor = RGB_COLOR(142, 142, 142);
        subtitle.numberOfLines = 0;
        subtitle.lineBreakMode = NSLineBreakByWordWrapping;
        _subTitleLabel = subtitle;
    }
    return _subTitleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(16, self.subTitleLabel.bottom+15, 250, 18)];
        price.font =FONT(18);
        price.textColor = RGB_COLOR(50, 189, 111);
        
        
        NSString *priceText = [NSString stringWithFormat:@"￥%.2f  ￥%.2f",[_item[@"price"] floatValue],[_item[@"mprice"] floatValue]];
        
        
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:priceText];
        
        NSRange range = [priceText rangeOfString:[NSString stringWithFormat:@"￥%.2f",[_item[@"mprice"] floatValue]]];
        
        
        [content addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:RGB_COLOR(154, 154, 154),NSForegroundColorAttributeName:RGB_COLOR(154, 154, 154),NSFontAttributeName:FONT(16)} range:range];
        
        price.attributedText = content;
        
        _priceLabel = price;
    }
    return _priceLabel;
}

//- (CrossLineLabel *)mpriceLabel
//{
//    if (!_mpriceLabel) {
//        _mpriceLabel = [[CrossLineLabel alloc] initWithFrame:CGRectMake(self.priceLabel.right+5, self.subTitleLabel.bottom+15, 100, 18)];
//        
//        _mpriceLabel.text = [NSString stringWithFormat:@"市场价:￥%@",_item[@"mprice"]];
//        _mpriceLabel.font = FONT(14);
//        _mpriceLabel.textColor = RGB_COLOR(154, 154, 154);
//    }
//      return _mpriceLabel;
//}
//
//- (UILabel *)cLabel
//{
//    if (!_cLabel) {
//        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-10, self.priceLabel.bottom-12, 80, 12)];
//        count.textAlignment = NSTextAlignmentRight;
//        count.text = [NSString stringWithFormat:@"%@人选择",@(_tcdata.sales)];
//        count.font = FONT(12);
//        count.textColor = RGB_COLOR(154, 154, 154);
//        _cLabel = count;
//    }
//    return _cLabel;
//}

- (UIImageView *)cImageView
{
    if (!_cImageView) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_title"]];
        imageView.frame = CGRectMake((SCREEN_WIDTH-516/2.0)/2.0, 10, 516/2.0, 43);

        _cImageView = imageView;
    }
    return _cImageView;
}


@end
