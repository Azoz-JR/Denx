//
//  ContactListViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ContactListViewController.h"
#import "ContactAddViewController.h"
#import "ContactEditViewController.h"

@interface ContactListViewController ()<UITableViewDelegate,UITableViewDataSource,ContactAddViewControllerDelegate,ContactEditViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 添加按钮
@property (nonatomic, strong) UIButton *addButton;

#pragma mark Data

@property(nonatomic, strong) NSMutableArray <ContactSetModel *>*contactArray;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 编辑下标
@property (nonatomic, assign) NSInteger editIndex;

@end

@implementation ContactListViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [PPGetAddressBook requestAddressBookAuthorization];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < self.contactArray.count; i++) {
        ContactSetModel *model = self.contactArray[i];
        DHContactSetModel *contactModel = [[DHContactSetModel alloc] init];
        contactModel.name = model.name;
        contactModel.mobile = model.mobile;
        [models addObject:contactModel];
    }
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setContacts:models block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveContacts];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
}

- (void)saveContacts {
    //删除
    NSArray *array = [ContactSetModel queryAllContacts];
    if (array.count) {
        [ContactSetModel deleteObjects:array];
    }
    //保存
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < self.contactArray.count; i++) {
        ContactSetModel *model = self.contactArray[i];
        model.contactIndex = i;
        [resultArray addObject:model];
    }
    if (resultArray.count) {
        [ContactSetModel saveObjects:resultArray];
    }
}

- (void)initData {
    [self.dataArray removeAllObjects];
    
    for (int i = 0; i < self.contactArray.count; i++) {
        ContactSetModel *model = self.contactArray[i];
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = model.name;
        cellModel.contentTitle = model.mobile;
        [self.dataArray addObject:cellModel];
    }

}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.width.offset(50);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.equalTo(self.addButton.mas_top).offset(-10);
    }];
}

- (void)addClick {
    if (self.contactArray.count >= 20) {
        SHOWHUD(Lang(@"str_max_contact_count"))
        return;
    }
    ContactAddViewController *vc = [[ContactAddViewController alloc] init];
    vc.delegate = self;
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_address_book");
    [self.navigationController pushViewController:vc animated:YES];
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
    self.editIndex = indexPath.row;
    ContactEditViewController *vc = [[ContactEditViewController alloc] init];
    vc.navTitle = Lang(@"str_address_book");
    vc.delegate = self;
    vc.model = self.contactArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 添加删除功能

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Lang(@"str_delete");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contactArray removeObjectAtIndex:indexPath.row];
        [self initData];
        [self.myTableView reloadData];
    }
}

#pragma mark - ContactAddViewControllerDelegate,ContactEditViewControllerDelegate

- (void)contactUpdate:(ContactSetModel *)model {
    //查重
    if (self.contactArray.count > 1) {
        for (int i = 0; i < self.contactArray.count; i++) {
            if (i != self.editIndex) {
                ContactSetModel *item = self.contactArray[i];
                if ([item.name isEqualToString:model.name] && [item.mobile isEqualToString:model.mobile]) {
                    SHOWHUD(Lang(@"str_contact_already_exists"))
                    return;
                }
            }
        }
    }
    
    [self.contactArray replaceObjectAtIndex:self.editIndex withObject:model];
    [self initData];
    [self.myTableView reloadData];
}

- (void)contactAdd:(ContactSetModel *)model {
    //查重
    if (self.contactArray.count) {
        for (ContactSetModel *item in self.contactArray) {
            if ([item.name isEqualToString:model.name] && [item.mobile isEqualToString:model.mobile]) {
                SHOWHUD(Lang(@"str_contact_already_exists"))
                return;
            }
        }
    }
    
    [self.contactArray addObject:model];
    [self initData];
    [self.myTableView reloadData];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 90;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:DHImage(@"device_alarm_add") forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray <ContactSetModel *>*)contactArray {
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
        NSArray *array = [ContactSetModel queryAllContacts];
        if (array.count) {
            [_contactArray addObjectsFromArray:array];
        }
    }
    return _contactArray;
}

@end
