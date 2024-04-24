//
//  ContactAddViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ContactAddViewController.h"

@interface ContactAddViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSDictionary *addressbook;

@property (nonatomic, strong) NSArray *nameIndexes;
/// 头部高度
@property (nonatomic, assign) CGFloat headerViewH;

@end

@implementation ContactAddViewController

#pragma mark - vc lift cycle 生命周期

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self queryContacts];
    
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    self.headerViewH = 30;
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

- (void)queryContacts {
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    WEAKSELF
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
        for (NSString * key in addressBookDict.allKeys) {
            NSArray * persons = addressBookDict[key];
            NSMutableArray * addedPersons = [NSMutableArray array];
            for (PPPersonModel * model in persons) {
                if (model.mobileArray.count > 0) {
                    for (int i = 0; i < model.mobileArray.count; ++i) {
                        PPPersonModel* addP = [[PPPersonModel alloc]init];
                        addP.name = model.name;
                        NSString * mobile = model.mobileArray[i];
                        addP.mobileArray = [NSMutableArray arrayWithArray:@[mobile]];
                        [addedPersons addObject:addP];
                    }
                }
            }
            [mdic setObject:addedPersons forKey:key];
        }
        
        weakSelf.addressbook = mdic.copy;
        weakSelf.nameIndexes = nameKeys.copy;
        //addressBookDict: 装着所有联系人的字典
        //nameKeys: A~Z拼音字母数组;
        //刷新 tableView
        [weakSelf.myTableView reloadData];
    } authorizationFailure:^{
        [weakSelf showUnauthorizedTips];
    }];
}

- (void)showUnauthorizedTips {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:Lang(@"str_contact_permission_title")
                     message:Lang(@"str_contact_permission_message")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

-(NSArray *)nameIndexes{
   if (!_nameIndexes) {
       _nameIndexes = [NSArray array];
   }
   return _nameIndexes;
}

-(NSDictionary *)addressbook{
   if (!_addressbook) {
       _addressbook = [[NSDictionary alloc]init];
   }
   return _addressbook;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return  self.nameIndexes.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   NSString * key = self.nameIndexes[section];
   return [self.addressbook[key] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = self.nameIndexes[indexPath.section];
    PPPersonModel * person = self.addressbook[key][indexPath.row];
    
    MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
    cellModel.leftTitle = person.name;
    cellModel.contentTitle = person.mobileArray.firstObject;
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    cell.model = cellModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return self.headerViewH;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   return self.nameIndexes[section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
   return  self.nameIndexes;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   NSString * key = self.nameIndexes[indexPath.section];
   PPPersonModel * person = self.addressbook[key][indexPath.row];
    
    ContactSetModel *model = [[ContactSetModel alloc] init];
    model.name = person.name;
    model.mobile = person.mobileArray.firstObject;

    if ([self.delegate respondsToSelector:@selector(contactAdd:)]) {
        [self.delegate contactAdd:model];
    }
   [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 90;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionIndexBackgroundColor = HomeColor_BackgroundColor;
        _myTableView.sectionIndexColor = HomeColor_TitleColor;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

@end
