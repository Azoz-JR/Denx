//
//  DialListViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/22.
//

#import "DialListViewController.h"
#import "DialMarketListCell.h"
#import "DialDetailViewController.h"

@interface DialListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DialDetailViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UICollectionView *myCollectionView;
/// 下拉刷新
@property (nonatomic, strong) MJRefreshNormalHeader *mjRefreshHeader;
/// 上拉加载更多
@property (nonatomic, strong) MJRefreshAutoNormalFooter *mjRefreshFooter;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 当前页
@property (nonatomic, assign) NSInteger currentPage;
/// 一页长度
@property (nonatomic, assign) NSInteger pageSize;
/// 没有更多数据
@property (nonatomic, assign) BOOL isNoMoreData;

@end

@implementation DialListViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    self.pageSize = 12;
    self.isNoMoreData = NO;
    
    [self setupUI];
    
    [self.myCollectionView.mj_header beginRefreshing];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)headerRefresh {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(self.dialType) forKey:@"classify"];
    [dict setObject:@(1) forKey:@"pageIndex"];
    [dict setObject:@(self.pageSize) forKey:@"pageSize"];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    WEAKSELF
    [NetworkManager queryAllDialWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0) {
                NSInteger total = DHIsNotEmpty(data, @"total") ? [[data objectForKey:@"total"] integerValue] : 0;
                NSArray *array = DHIsNotEmpty(data, @"rows") ? [data objectForKey:@"rows"] : [NSArray array];
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [weakSelf updateHeaderDialData:array];
                }
                //重置数据
                weakSelf.currentPage = 2;
                weakSelf.isNoMoreData = (weakSelf.dataArray.count >= total);
                [weakSelf.myCollectionView reloadData];
                if (!weakSelf.myCollectionView.mj_footer) {
                    weakSelf.myCollectionView.mj_footer = weakSelf.mjRefreshFooter;
                }
            } else {
                SHOWHUD(Lang(@"str_refresh_failed"));
            }
            [weakSelf.myCollectionView.mj_header endRefreshing];
            weakSelf.myCollectionView.mj_footer.state = weakSelf.isNoMoreData ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        });
    }];
}

- (void)footerRefresh {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(self.dialType) forKey:@"classify"];
    [dict setObject:@(self.currentPage) forKey:@"pageIndex"];
    [dict setObject:@(self.pageSize) forKey:@"pageSize"];
    [dict setObject:DHMacAddr forKey:@"deviceId"];

    WEAKSELF
    [NetworkManager queryAllDialWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0) {
                NSInteger total = DHIsNotEmpty(data, @"total") ? [[data objectForKey:@"total"] integerValue] : 0;
                NSArray *array = DHIsNotEmpty(data, @"rows") ? [data objectForKey:@"rows"] : [NSArray array];
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [weakSelf updateFooterDialData:array];
                }
                //重置数据
                weakSelf.currentPage++;
                weakSelf.isNoMoreData = (weakSelf.dataArray.count >= total);
                [weakSelf.myCollectionView reloadData];
            } else {
                SHOWHUD(Lang(@"str_refresh_failed"));
            }
            if (weakSelf.isNoMoreData) {
                [weakSelf.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.myCollectionView.mj_footer endRefreshing];
            }
        });
    }];
}


- (void)updateHeaderDialData:(NSArray *)array {
    NSMutableArray *dialArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *item = array[i];
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
    self.dataArray = [NSMutableArray arrayWithArray:dialArray];
}

- (void)updateFooterDialData:(NSArray *)array {
    NSMutableArray *dialArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *item = array[i];
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
    [self.dataArray addObjectsFromArray:dialArray];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DialMarketSetModel *cellModel = self.dataArray[indexPath.row];
    DialMarketListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DialMarketListCell" forIndexPath:indexPath];
    cell.model = cellModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DialMarketSetModel *cellModel = self.dataArray[indexPath.row];
    
    DialDetailViewController *vc = [[DialDetailViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_dial_detail");
    vc.model = cellModel;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - DialDetailViewControllerDelegate

- (void)dialUploadSuccess:(NSInteger)dialId {
    for (DialMarketSetModel *model in self.dataArray) {
        if (model.dialId == dialId) {
            model.downlaod = model.downlaod++;
            break;
        }
    }
}

#pragma mark - get and set 属性的set和get方法

- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        CGFloat screenHeight = DHDialHeight;
        CGFloat screenWidth = DHDialWidth;
        NSInteger imageWidth = (kScreenWidth-80)/3.0;
        NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
        CGFloat imageSpace = 20.0;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(imageWidth, imageHeight+40);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = imageSpace;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, kScreenHeight-kNavAndStatusHeight-kBottomHeight) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = HomeColor_BackgroundColor;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_myCollectionView registerClass:[DialMarketListCell class] forCellWithReuseIdentifier:@"DialMarketListCell"];
        
        _myCollectionView.mj_header = self.mjRefreshHeader;
    }
    return _myCollectionView;
}

- (MJRefreshNormalHeader *)mjRefreshHeader {
    if (!_mjRefreshHeader) {
        _mjRefreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_mjRefreshHeader setTitle:Lang(@"str_drop_down_refresh") forState:MJRefreshStateIdle];
        [_mjRefreshHeader setTitle:Lang(@"str_refreshing") forState:MJRefreshStateRefreshing];
        [_mjRefreshHeader setTitle:Lang(@"str_release_refresh_now") forState:MJRefreshStatePulling];
        _mjRefreshHeader.stateLabel.textColor = COLOR(@"FFFFFF");
        _mjRefreshHeader.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _mjRefreshHeader.automaticallyChangeAlpha = YES;// 设置自动切换透明度(在导航栏下面自动隐藏)
        _mjRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _mjRefreshHeader;
}

- (MJRefreshAutoNormalFooter *)mjRefreshFooter {
    if (!_mjRefreshFooter) {
        _mjRefreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [_mjRefreshFooter setTitle:Lang(@"str_pull_up_to_load_more") forState:MJRefreshStateIdle];
        [_mjRefreshFooter setTitle:Lang(@"str_loading") forState:MJRefreshStateRefreshing];
        [_mjRefreshFooter setTitle:Lang(@"str_release_load_now") forState:MJRefreshStatePulling];
        [_mjRefreshFooter setTitle:Lang(@"str_no_more_data") forState:MJRefreshStateNoMoreData];
        _mjRefreshFooter.stateLabel.textColor = COLOR(@"FFFFFF");
        _mjRefreshFooter.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _mjRefreshFooter;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
