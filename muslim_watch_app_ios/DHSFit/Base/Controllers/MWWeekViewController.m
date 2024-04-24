//
//  MWWeekViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "MWWeekViewController.h"

@interface MWWeekViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MWWeekViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(repeatsUpdate:)]) {
        [self.delegate repeatsUpdate:self.selectIndexs];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.rightImage = [self.selectIndexs[i] integerValue] == 1 ? @"public_cell_selected" : @"";
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cellModel.rightImage = cellModel.rightImage.length ? @"" : @"public_cell_selected";
    NSNumber *result = cellModel.rightImage.length ? @1 : @0;
    [self.selectIndexs replaceObjectAtIndex:indexPath.row withObject:result];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 60;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_sunday"),
                    Lang(@"str_monday"),
                    Lang(@"str_tuesday"),
                    Lang(@"str_wednesday"),
                    Lang(@"str_thursday"),
                    Lang(@"str_friday"),
                    Lang(@"str_saturday")];
        if ([DHBleCentralManager isJLProtocol]){
            _titles = @[Lang(@"str_monday"),
                        Lang(@"str_tuesday"),
                        Lang(@"str_wednesday"),
                        Lang(@"str_thursday"),
                        Lang(@"str_friday"),
                        Lang(@"str_saturday"),
                        Lang(@"str_sunday")];
        }
    }
    return _titles;
}
@end
