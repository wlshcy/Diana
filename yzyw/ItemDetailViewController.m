#import "ItemDetailViewController.h"
#import "LoginViewController.h"

@interface ItemDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *carBtn;

@property (nonatomic, assign) NSInteger count; //选择的数量；


@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;


@end

@implementation ItemDetailViewController

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
        [self getItemDetail];
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
        static NSString *cellIndentifier = @"imageCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell addSubview:self.titleLabel];
        [cell addSubview:self.descLabel];
        [cell addSubview:self.priceLabel];
        
        return cell;
    }
    else {
        static NSString *cellIndentifier = @"infoCell";
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
            cell.textLabel.text = @"规格";
            cell.textLabel.font = FONT(16);
	    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@g", _item[@"size"]];
            cell.detailTextLabel.textColor = RGB_COLOR(0, 0, 0);
            cell.detailTextLabel.font = FONT(16);
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"产地";
            cell.textLabel.font = FONT(16);
	    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _item[@"origin"]];
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y < -80) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Fetch data
- (void)getItemDetail
{
    [self showLoading];
    
    [HTTPManager showItem:self.vid success:^(NSDictionary *response) {
    
        [self hideLoading];
        
        _item = response;
        [self.view addSubview:self.topView];
        [self.topView addSubview:self.backBtn];
        [self configView];

        
    } failure:^(NSError *err) {
        [self hideLoading];
        [self showFailureStatusWithTitle:NET_TIPS];
        [self.view addSubview:self.topView];
        [self.topView addSubview:self.backBtn];

    }];
}


#pragma mark - UserAction
- (void)closePage:(UIButton *)sender
{
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

- (void)addShopCar:(UIButton *)sender
{
    if(_count == 0){
        return;
    }
    [[DBManager instance] deleteItem:_item];
    [[DBManager instance] saveItem:_item count:_count];
    
    [self showSuccessStatusWithTitle:@"成功加入购物车"];
    
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCartTabBadge];

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
        [_backBtn setImage:[UIImage imageNamed:@"detail_close"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 250, 16)];
        title.text = _item[@"name"];
        title.font =FONT(16);
        _titleLabel = title;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        
        CGFloat height = [_item[@"desc"] ew_heightWithFont:FONT(14) lineWidth:SCREEN_WIDTH-32];
        
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(16, self.titleLabel.bottom+10, SCREEN_WIDTH-32, height)];
        desc.text = _item[@"desc"];
        desc.font =FONT(14);
        desc.textColor = RGB_COLOR(142, 142, 142);
        desc.numberOfLines = 0;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel = desc;
    }
    return _descLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(16, self.descLabel.bottom+15, 250, 18)];
        price.font =FONT(18);
        price.textColor = RGB_COLOR(50, 189, 111);
        price.text = [NSString stringWithFormat:@"￥%.2f",[_item[@"price"] floatValue]];
        _priceLabel = price;
    }
    return _priceLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_title"]];
        imageView.frame = CGRectMake((SCREEN_WIDTH-516/2.0)/2.0, 10, 516/2.0, 43);

        _imageView = imageView;
    }
    return _imageView;
}

@end
