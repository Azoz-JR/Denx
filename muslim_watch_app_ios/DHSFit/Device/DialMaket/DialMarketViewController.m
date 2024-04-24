//
//  DialMarketViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DialMarketViewController.h"
#import "DialDetailViewController.h"
#import "CustomDialViewController.h"
#import "DialListViewController.h"
#import "BaseSelectedView.h"
#import "DialMaketCell.h"
#import "CustomDialCell.h"

@interface DialMarketViewController ()<UITableViewDelegate,UITableViewDataSource,DialMaketCellDelegate,CustomDialCellDelegate,BaseSelectedViewDelegate,UIScrollViewDelegate,CustomDialViewControllerDelegate,DialDetailViewControllerDelegate>

#pragma mark UI
/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 推荐视图
@property (nonatomic, strong) UIView *viewA;
/// 列表视图
@property (nonatomic, strong) UITableView *tableViewA;
/// 我的视图
@property (nonatomic, strong) UIView *viewB;
/// 列表视图
@property (nonatomic, strong) UITableView *tableViewB;

@property (nonatomic, strong) BaseSelectedView *topView;

#pragma mark Data

/// 推荐数据源
@property (nonatomic, strong) NSMutableArray *dataArrayA;
/// 推荐数据源
@property (nonatomic, strong) NSMutableArray *titleArrayA;

@property (nonatomic, strong) NSMutableArray *typeArrayA;
/// 我的数据源
@property (nonatomic, strong) NSMutableArray *dataArrayB;
/// 我的数据源
@property (nonatomic, strong) NSMutableArray *titleArrayB;

@property (nonatomic, strong) NSMutableArray *heightArrayA;

@property (nonatomic, strong) NSMutableArray *heightArrayB;

@property (nonatomic, strong) CustomDialSetModel *dialModel;

@end

@implementation DialMarketViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [self queryDialMarketArray];
    
    NSLog(@"screenType %d", [DHBluetoothManager shareInstance].dialInfoModel.screenType);
}

- (void)queryDialMarketArray {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    [dict setObject:[[LanguageManager shareInstance] getHttpLanguageType] forKey:@"language"];

    WEAKSELF
    [NetworkManager queryRecommendDialWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0 && [data isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)data;
                if (array.count) {
                    [weakSelf updateDialViewCell:array];
                }
            }
        });
    }];
}

- (void)updateDialViewCell:(NSArray *)array {

    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    
    NSInteger imageWidth = (kScreenWidth - 30 - 80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        if ([dict objectForKey:@"classifyName"]) {
            NSString *titleStr = [dict objectForKey:@"classifyName"];
            [self.titleArrayA addObject:titleStr];
        }
        
        if (DHIsNotEmpty(dict, @"classifyId")) {
            NSInteger dialType = [[dict objectForKey:@"classifyId"] integerValue];
            [self.typeArrayA addObject:@(dialType)];
        }
        
        if (DHIsNotEmpty(dict, @"dials")) {
            NSArray *items = [dict objectForKey:@"dials"];
            if ([items isKindOfClass:[NSArray class]] && items.count) {
                NSMutableArray *dialArray = [NSMutableArray array];
                for (NSDictionary *item in items) {
                    DialMarketSetModel *model = [[DialMarketSetModel alloc] init];
                    model.name = DHIsNotEmpty(item, @"name") ? [item objectForKey:@"name"] : @"";
                    model.thumbnailPath = DHIsNotEmpty(item, @"previewUrl") ? [item objectForKey:@"previewUrl"] : @"";
                    model.imagePath = DHIsNotEmpty(item, @"previewUrl") ? [item objectForKey:@"previewUrl"] : @"";
                    model.filePath = DHIsNotEmpty(item, @"downloadUrl") ? [item objectForKey:@"downloadUrl"] : @"";
                    model.fileSize = DHIsNotEmpty(item, @"size") ? [[item objectForKey:@"size"] integerValue] : 0;
                    model.downlaod = DHIsNotEmpty(item, @"useCount") ? [[item objectForKey:@"useCount"] integerValue] : 0;
                    model.price = 0;
                    model.desc = DHIsNotEmpty(item, @"description") ? [item objectForKey:@"description"] : @"";
                    model.dialId = DHIsNotEmpty(item, @"id") ? [[item objectForKey:@"id"] integerValue] : 0;
                    [dialArray addObject:model];
                }
                CGFloat lineCount = dialArray.count%3 == 0 ? dialArray.count/3 : dialArray.count/3+1;
                [self.dataArrayA addObject:dialArray];
                [self.heightArrayA addObject:@(44+20+(imageHeight+40)*lineCount)];
            } else {
                self.dataArrayA = [NSMutableArray array];
                [self.heightArrayA addObject:@(0)];
            }
        }
    }
    [self.tableViewA reloadData];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.dialModel = [CustomDialSetModel currentModel];
    
    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    
    NSInteger imageWidth = (kScreenWidth-30-80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    
    for (int i = 0; i < 1; i ++) {
        NSMutableArray *rowArray = [NSMutableArray array];
        
        [rowArray addObject:self.dialModel];
        
        [self.dataArrayB addObject:rowArray];
        [self.heightArrayB addObject:@(44+20+(imageHeight+15)*1)];
        [self.titleArrayB addObject:Lang(@"str_dial_custom")];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    CGFloat bgViewH = kScreenHeight-kNavAndStatusHeight-kBottomHeight-60;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(50);
    }];
    [self.topView setupSubViews];
    
    if ([DHBleCentralManager isJLProtocol]){
        self.topView.hidden = YES;
    }
    
    self.myScrollView = [[UIScrollView alloc] init];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.scrollEnabled = NO;
    [self.view addSubview:self.myScrollView];
    
    [self.viewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myScrollView.mas_left);
        make.width.equalTo(self.myScrollView);
        make.top.equalTo(self.myScrollView);
        make.height.equalTo(self.myScrollView);
    }];
    
    [self.viewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewA.mas_right);
        make.top.bottom.equalTo(self.viewA);
        make.width.equalTo(self.viewA);
    }];
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.height.offset(bgViewH);
        make.right.equalTo(self.viewB.mas_right);
    }];
    
    [self.tableViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
    [self.tableViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
}

- (void)updateScrollViewOffset:(NSInteger)index {
    [self.myScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:NO];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewA]) {
        return self.dataArrayA.count;
    }
    return self.dataArrayB.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableViewA]) {
        return [self.heightArrayA[indexPath.row] floatValue];
    }
    return [self.heightArrayB[indexPath.row] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableViewA]) {
        DialMaketCell *cellA = [tableView dequeueReusableCellWithIdentifier:@"DialMaketCell" forIndexPath:indexPath];
        cellA.selectionStyle = UITableViewCellSelectionStyleNone;
        cellA.dialArray = self.dataArrayA[indexPath.row];
        cellA.leftTitleLabel.text = self.titleArrayA[indexPath.row];
        cellA.dialType = [self.typeArrayA[indexPath.row] integerValue];
        cellA.delegate = self;
        
        return cellA;
    }
    //NSArray *rowArray = self.dataArrayB[indexPath.row];
    //CustomDialSetModel *cellModel = rowArray.firstObject;
    CustomDialCell *cellB = [tableView dequeueReusableCellWithIdentifier:@"CustomDialCell" forIndexPath:indexPath];
    cellB.selectionStyle = UITableViewCellSelectionStyleNone;
    cellB.delegate = self;
    if (self.dialModel.imagePath.length) {
        NSString *macAddr = [DHMacAddr stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSData *imageData = [DHFile queryLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%@.png" ,macAddr]];
        if (imageData) {
            cellB.leftImageView.image = [UIImage imageWithData:imageData];
        } else {
            cellB.leftImageView.image = [CustomDialCell imageFromColor:[UIColor blackColor] size:cellB.leftImageView.frame.size];
        }
    } else {
        cellB.leftImageView.image =  [CustomDialCell imageFromColor:[UIColor blackColor] size:cellB.leftImageView.frame.size];
    }
    
    return cellB;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.myScrollView) {
        int number = scrollView.contentOffset.x/kScreenWidth;
        [self.topView updateTypeSelected:number];
        [self updateScrollViewOffset:number];
    }
}

#pragma mark - DialMaketCellDelegate

- (void)onMoreDials:(NSString *)title Type:(NSInteger)dialType {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DialListViewController *vc = [[DialListViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = title;
    vc.dialType = dialType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDial:(DialMarketSetModel *)model {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    DialDetailViewController *vc = [[DialDetailViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_dial_detail");
    vc.model = model;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DialDetailViewControllerDelegate

- (void)dialUploadSuccess:(NSInteger)dialId {
    for (int i = 0; i < self.dataArrayA.count; i++) {
        NSArray *dialArray = self.dataArrayA[i];
        if (dialArray.count) {
            for (DialMarketSetModel *model in dialArray) {
                if (model.dialId == dialId) {
                    model.downlaod = model.downlaod++;
                    break;
                }
            }
        }
    }
}

#pragma mark - CustomDialCellDelegate

- (void)onCustomDial {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    CustomDialViewController *vc = [[CustomDialViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_dial_custom");
    vc.model = self.dialModel;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BaseSelectedViewDelegate

- (void)onTypeSelected:(NSInteger)index {
    [self updateScrollViewOffset:index];
}

#pragma mark - CustomDialViewControllerDelegate

- (void)customDialInstallSuccess:(CustomDialSetModel *)model {
    self.dialModel = model;
    [self.tableViewB reloadData];
}

#pragma mark - get and set 属性的set和get方法

- (BaseSelectedView *)topView {
    if (!_topView) {
        _topView = [[BaseSelectedView alloc] init];
        _topView.titles = @[Lang(@"str_recommend"),Lang(@"str_tab_mine")];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIView *)viewA {
    if (!_viewA) {
        _viewA = [[UIView alloc] init];
        _viewA.backgroundColor = HomeColor_BackgroundColor;
        [self.myScrollView addSubview:_viewA];
    }
    return _viewA;
}

- (UIView *)viewB {
    if (!_viewB) {
        _viewB = [[UIView alloc] init];
        _viewB.backgroundColor = HomeColor_BackgroundColor;
        [self.myScrollView addSubview:_viewB];
    }
    return _viewB;
}

- (UITableView *)tableViewA {
    if (!_tableViewA) {
        _tableViewA = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewA.backgroundColor = HomeColor_BackgroundColor;
        _tableViewA.showsVerticalScrollIndicator = NO;
        _tableViewA.showsHorizontalScrollIndicator = NO;
        _tableViewA.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewA.delegate = self;
        _tableViewA.dataSource = self;
        [_tableViewA registerClass:[DialMaketCell class] forCellReuseIdentifier:@"DialMaketCell"];
        [self.viewA addSubview:_tableViewA];
    }
    return _tableViewA;
}

- (UITableView *)tableViewB {
    if (!_tableViewB) {
        _tableViewB = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewB.backgroundColor = HomeColor_BackgroundColor;
        _tableViewB.showsVerticalScrollIndicator = NO;
        _tableViewB.showsHorizontalScrollIndicator = NO;
        _tableViewB.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewB.delegate = self;
        _tableViewB.dataSource = self;
        [_tableViewB registerClass:[CustomDialCell class] forCellReuseIdentifier:@"CustomDialCell"];
        [self.viewB addSubview:_tableViewB];
    }
    return _tableViewB;
}

- (NSMutableArray *)dataArrayA {
    if (!_dataArrayA) {
        _dataArrayA = [NSMutableArray array];
    }
    return _dataArrayA;
}

- (NSMutableArray *)dataArrayB {
    if (!_dataArrayB) {
        _dataArrayB = [NSMutableArray array];
    }
    return _dataArrayB;
}

- (NSMutableArray *)heightArrayA {
    if (!_heightArrayA) {
        _heightArrayA = [NSMutableArray array];
    }
    return _heightArrayA;
}

- (NSMutableArray *)heightArrayB {
    if (!_heightArrayB) {
        _heightArrayB = [NSMutableArray array];
    }
    return _heightArrayB;
}

- (NSMutableArray *)titleArrayA {
    if (!_titleArrayA) {
        _titleArrayA = [NSMutableArray array];
    }
    return _titleArrayA;
}

- (NSMutableArray *)titleArrayB {
    if (!_titleArrayB) {
        _titleArrayB = [NSMutableArray array];
    }
    return _titleArrayB;
}

- (NSMutableArray *)typeArrayA {
    if (!_typeArrayA) {
        _typeArrayA = [NSMutableArray array];
    }
    return _typeArrayA;
}


@end
