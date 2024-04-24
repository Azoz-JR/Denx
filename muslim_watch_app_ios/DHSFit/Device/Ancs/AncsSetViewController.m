//
//  AncsSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import "AncsSetViewController.h"

@interface AncsSetViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) AncsSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) BOOL isAll;
/// 来电（0.关 1.开）
@property (nonatomic, assign) BOOL isCall;
/// 短信
@property (nonatomic, assign) BOOL isSMS;
/// QQ
@property (nonatomic, assign) BOOL isQQ;
/// 微信
@property (nonatomic, assign) BOOL isWechat;
/// Whatsapp
@property (nonatomic, assign) BOOL isWhatsapp;
/// Messenger
@property (nonatomic, assign) BOOL isMessenger;
/// Twitter
@property (nonatomic, assign) BOOL isTwitter;
/// Linkedin
@property (nonatomic, assign) BOOL isLinkedin;

/// Instagram
@property (nonatomic, assign) BOOL isInstagram;
/// Facebook
@property (nonatomic, assign) BOOL isFacebook;
/// Line
@property (nonatomic, assign) BOOL isLine;
/// 企业微信
@property (nonatomic, assign) BOOL isWechatWork;
/// Dingding
@property (nonatomic, assign) BOOL isDingding;
/// Email
@property (nonatomic, assign) BOOL isEmail;
/// Calendar
@property (nonatomic, assign) BOOL isCalendar;
/// Viber
@property (nonatomic, assign) BOOL isViber;

/// Skype
@property (nonatomic, assign) BOOL isSkype;
/// Kakaotalk
@property (nonatomic, assign) BOOL isKakaotalk;
/// Tumblr
@property (nonatomic, assign) BOOL isTumblr;
/// Snapchat
@property (nonatomic, assign) BOOL isSnapchat;
/// Youtube
@property (nonatomic, assign) BOOL isYoutube;
/// Pinterset
@property (nonatomic, assign) BOOL isPinterset;
/// Tiktok
@property (nonatomic, assign) BOOL isTiktok;
/// Gmail
@property (nonatomic, assign) BOOL isGmail;

/// 其他
@property (nonatomic, assign) BOOL isOther;

@end

@implementation AncsSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAncs];
}

- (void)getAncs {
    WEAKSELF
    [DHBleCommand getAncs:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [AncsSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
    }];
}

- (void)saveModel:(id)data {
    DHAncsSetModel *model = data;
    AncsSetModel *ancsModel = [AncsSetModel currentModel];

    ancsModel.isCall = model.isCall;
    ancsModel.isSMS = model.isSMS;
    ancsModel.isQQ = model.isQQ;
    ancsModel.isWechat = model.isWechat;
    ancsModel.isWhatsapp = model.isWhatsapp;
    ancsModel.isMessenger = model.isMessenger;
    ancsModel.isTwitter = model.isTwitter;
    ancsModel.isLinkedin = model.isLinkedin;
    
    ancsModel.isInstagram = model.isInstagram;
    ancsModel.isFacebook = model.isFacebook;
    ancsModel.isLine = model.isLine;
    ancsModel.isWechatWork = model.isWechatWork;
    ancsModel.isDingding = model.isDingding;
    ancsModel.isEmail = model.isEmail;
    ancsModel.isCalendar = model.isCalendar;
    ancsModel.isViber = model.isViber;
    
    ancsModel.isSkype = model.isSkype;
    ancsModel.isKakaotalk = model.isKakaotalk;
    ancsModel.isTumblr = model.isTumblr;
    ancsModel.isSnapchat = model.isSnapchat;
    ancsModel.isYoutube = model.isYoutube;
    ancsModel.isPinterset = model.isPinterset;
    ancsModel.isTiktok = model.isTiktok;
    ancsModel.isGmail = model.isGmail;
    
    ancsModel.isOther = model.isOther;
    [ancsModel saveOrUpdate];
    
    self.model = ancsModel;
}


#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DHAncsSetModel *model = [[DHAncsSetModel alloc] init];
    model.isCall = self.isCall;
    model.isSMS = self.isSMS;
    model.isQQ = self.isQQ;
    model.isWechat = self.isWechat;
    model.isWhatsapp = self.isWhatsapp;
    model.isMessenger = self.isMessenger;
    model.isTwitter = self.isTwitter;
    model.isLinkedin = self.isLinkedin;
    
    model.isInstagram = self.isInstagram;
    model.isFacebook = self.isFacebook;
    model.isLine = self.isLine;
    model.isWechatWork = self.isWechatWork;
    model.isDingding = self.isDingding;
    model.isEmail = self.isEmail;
    model.isCalendar = self.isCalendar;
    model.isViber = self.isViber;
    
    model.isSkype = self.isSkype;
    model.isKakaotalk = self.isKakaotalk;
    model.isTumblr = self.isTumblr;
    model.isSnapchat = self.isSnapchat;
    model.isYoutube = self.isYoutube;
    model.isPinterset = self.isPinterset;
    model.isTiktok = self.isTiktok;
    model.isGmail = self.isGmail;

    model.isOther = self.isOther;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setAncs:model block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveModel];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
    

}

- (void)saveModel {
    
    self.model.isCall = self.isCall;
    self.model.isSMS = self.isSMS;
    self.model.isQQ = self.isQQ;
    self.model.isWechat = self.isWechat;
    self.model.isWhatsapp = self.isWhatsapp;
    self.model.isMessenger = self.isMessenger;
    self.model.isTwitter = self.isTwitter;
    self.model.isLinkedin = self.isLinkedin;
    
    self.model.isInstagram = self.isInstagram;
    self.model.isFacebook = self.isFacebook;
    self.model.isLine = self.isLine;
    self.model.isWechatWork = self.isWechatWork;
    self.model.isDingding = self.isDingding;
    self.model.isEmail = self.isEmail;
    self.model.isCalendar = self.isCalendar;
    self.model.isViber = self.isViber;
    
    self.model.isSkype = self.isSkype;
    self.model.isKakaotalk = self.isKakaotalk;
    self.model.isTumblr = self.isTumblr;
    self.model.isSnapchat = self.isSnapchat;
    self.model.isYoutube = self.isYoutube;
    self.model.isPinterset = self.isPinterset;
    self.model.isTiktok = self.isTiktok;
    self.model.isGmail = self.isGmail;

    self.model.isOther = self.isOther;
    
    [self.model saveOrUpdate];
}

- (void)initData {
    
    self.isCall = self.model.isCall;
    self.isSMS = self.model.isSMS;
    self.isQQ = self.model.isQQ;
    self.isWechat = self.model.isWechat;
    self.isWhatsapp = self.model.isWhatsapp;
    self.isMessenger = self.model.isMessenger;
    self.isTwitter = self.model.isTwitter;
    self.isLinkedin = self.model.isLinkedin;
    
    self.isInstagram = self.model.isInstagram;
    self.isFacebook = self.model.isFacebook;
    self.isLine = self.model.isLine;
    self.isWechatWork = self.model.isWechatWork;
    self.isDingding = self.model.isDingding;
    self.isEmail = self.model.isEmail;
    self.isCalendar = self.model.isCalendar;
    self.isViber = self.model.isViber;
    
    self.isSkype = self.model.isSkype;
    self.isKakaotalk = self.model.isKakaotalk;
    self.isTumblr = self.model.isTumblr;
    self.isSnapchat = self.model.isSnapchat;
    self.isYoutube = self.model.isYoutube;
    self.isPinterset = self.model.isPinterset;
    self.isTiktok = self.model.isTiktok;
    self.isGmail = self.model.isGmail;
    
    self.isOther = self.model.isOther;
    
    self.isAll = (self.isSMS &&
                  self.isQQ &&
                  self.isWechat &&
                  self.isWhatsapp &&
                  self.isMessenger &&
                  self.isTwitter &&
                  self.isLinkedin &&
                  
                  self.isInstagram &&
                  self.isFacebook &&
                  self.isLine &&
                  self.isWechatWork &&
                  self.isDingding &&
                  self.isEmail &&
                  self.isCalendar &&
                  self.isViber &&
                  
                  self.isSkype &&
                  self.isKakaotalk &&
                  self.isTumblr &&
                  self.isSnapchat &&
                  
                  self.isYoutube &&
                  self.isPinterset &&
                  self.isTiktok &&
                  self.isGmail &&
                  self.isOther);
    
    for (int i = 0; i < self.titles.count; i++) {
        NSString *leftTitle = self.titles[i];
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftImage = self.images[i];
        cellModel.leftTitle = leftTitle;
        cellModel.isHideArrow = YES;
        cellModel.isHideSwitch = NO;
        cellModel.switchViewTag = 100+i;
        
        if (i == 0) {
            cellModel.isOpen = self.isAll;
        } else if (i == 1) {
            cellModel.isOpen = self.isSMS;
        } else if (i == 2) {
            cellModel.isOpen = self.isQQ;
        } else if (i == 3) {
            cellModel.isOpen = self.isWechat;
        } else if (i == 4) {
            cellModel.isOpen = self.isWhatsapp;
        } else if (i == 5) {
            cellModel.isOpen = self.isMessenger;
        } else if (i == 6) {
            cellModel.isOpen = self.isTwitter;
        } else if (i == 7) {
            cellModel.isOpen = self.isLinkedin;
        } else if (i == 8) {
            cellModel.isOpen = self.isInstagram;
        } else if (i == 9) {
            cellModel.isOpen = self.isFacebook;
        } else if (i == 10) {
            cellModel.isOpen = self.isLine;
        } else if (i == 11) {
            cellModel.isOpen = self.isWechatWork;
        } else if (i == 12) {
            cellModel.isOpen = self.isDingding;
        } else if (i == 13) {
            cellModel.isOpen = self.isEmail;
        } else if (i == 14) {
            cellModel.isOpen = self.isCalendar;
        } else if (i == 15) {
            cellModel.isOpen = self.isViber;
        } else if (i == 16) {
            cellModel.isOpen = self.isSkype;
        } else if (i == 17) {
            cellModel.isOpen = self.isKakaotalk;
        } else if (i == 18) {
            cellModel.isOpen = self.isTumblr;
        } else if (i == 19) {
            cellModel.isOpen = self.isSnapchat;
        } else if (i == 20) {
            cellModel.isOpen = self.isYoutube;
        } else if (i == 21) {
            cellModel.isOpen = self.isPinterset;
        } else if (i == 22) {
            cellModel.isOpen = self.isTiktok;
        } else if (i == 23) {
            cellModel.isOpen = self.isGmail;
        } else if (i == 24) {
            cellModel.isOpen = self.isOther;
        }
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

- (void)switchViewValueChanged:(UISwitch *)sender {
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if (sender.tag - 100 == i && i == 0) {
            self.isAll = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 1) {
            self.isSMS = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 2) {
            self.isQQ = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 3) {
            self.isWechat = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 4) {
            self.isWhatsapp = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 5) {
            self.isMessenger = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 6) {
            self.isTwitter = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 7) {
            self.isLinkedin = sender.isOn;
            cellModel.isOpen = sender.isOn;
        } else if (sender.tag - 100 == i && i == 8) {
           self.isInstagram = sender.isOn;
            cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 9) {
           self.isFacebook = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 10) {
           self.isLine = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 11) {
           self.isWechatWork = sender.isOn;
           cellModel.isOpen = self.isWechatWork;
       } else if (sender.tag - 100 == i && i == 12) {
           self.isDingding = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 13) {
           self.isEmail = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 14) {
           self.isCalendar = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 15) {
           self.isViber = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 16) {
           self.isSkype = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 17) {
           self.isKakaotalk = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 18) {
           self.isTumblr = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 19) {
           self.isSnapchat = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 20) {
           self.isYoutube = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 21) {
           self.isPinterset = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 22) {
           self.isTiktok = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 23) {
           self.isGmail = sender.isOn;
           cellModel.isOpen = sender.isOn;
       } else if (sender.tag - 100 == i && i == 24) {
           self.isOther = sender.isOn;
           cellModel.isOpen = sender.isOn;
       }
    }
    
    if (sender.tag == 100) {
        for (int i = 1; i < self.dataArray.count; i++) {
            MWBaseCellModel *cellModel = self.dataArray[i];
            cellModel.isOpen = self.isAll;
        }
        self.isSMS = self.isAll;
        self.isQQ = self.isAll;
        self.isWechat = self.isAll;
        self.isWhatsapp = self.isAll;
        self.isMessenger = self.isAll;
        self.isTwitter = self.isAll;
        self.isLinkedin = self.isAll;
        
        self.isInstagram = self.isAll;
        self.isFacebook = self.isAll;
        self.isLine = self.isAll;
        self.isWechatWork = self.isAll;
        self.isDingding = self.isAll;
        self.isEmail = self.isAll;
        self.isCalendar = self.isAll;
        self.isViber = self.isAll;
        
        self.isSkype = self.isAll;
        self.isKakaotalk = self.isAll;
        self.isTumblr = self.isAll;
        self.isSnapchat = self.isAll;
        self.isYoutube = self.isAll;
        self.isPinterset = self.isAll;
        self.isTiktok = self.isAll;
        self.isGmail = self.isAll;
        
        self.isOther = self.isAll;
        
        [self.myTableView reloadData];
    } else {
        if (self.isAll && !sender.isOn) {
            MWBaseCellModel *cellModel = [self.dataArray firstObject];
            cellModel.isOpen = NO;
            self.isAll = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else if (self.isSMS &&
                   self.isQQ &&
                   self.isWechat &&
                   self.isWhatsapp &&
                   self.isMessenger &&
                   self.isTwitter &&
                   self.isLinkedin &&
                   
                   self.isInstagram &&
                   self.isFacebook &&
                   self.isLine &&
                   self.isWechatWork &&
                   self.isDingding &&
                   self.isEmail &&
                   self.isCalendar &&
                   self.isViber &&
                   
                   self.isSkype &&
                   self.isKakaotalk &&
                   self.isTumblr &&
                   self.isSnapchat &&
                   
                   self.isYoutube &&
                   self.isPinterset &&
                   self.isTiktok &&
                   self.isGmail &&
                   self.isOther) {
            MWBaseCellModel *cellModel = [self.dataArray firstObject];
            cellModel.isOpen = YES;
            self.isAll = YES;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
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
    cell.isHeader = indexPath.row == 0 ? YES : NO;
    if (!cellModel.isHideSwitch) {
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.switchView.tag = cellModel.switchViewTag;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70.0;
    }
    return 60.0;
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_myTableView.rowHeight = 60;
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
        _titles = @[Lang(@"str_select_all"),
                    Lang(@"str_sms"),
                    Lang(@"str_qq"),
                    Lang(@"str_wechat"),
                    Lang(@"str_whatsapp"),
                    
                    Lang(@"str_messenger"),
                    Lang(@"str_twitter"),
                    Lang(@"str_linkedin"),
                    Lang(@"str_instagram"),
                    Lang(@"str_facebook"),
                    
                    Lang(@"str_line"),
                    Lang(@"str_e_wechat"),
                    Lang(@"str_dingding"),
                    Lang(@"str_email"),
                    Lang(@"str_calendar"),
                    
                    Lang(@"str_viber"),
                    Lang(@"str_skype"),
                    Lang(@"str_kakaotalk"),
                    Lang(@"str_tumblr"),
                    Lang(@"str_snapchat"),
                    
                    Lang(@"str_youtube"),
                    Lang(@"str_pinterset"),
                    Lang(@"str_tiktok"),
                    Lang(@"str_gmail"),
                    Lang(@"str_other")];
    }
    return _titles;
}

- (NSArray *)images {
    
    if (!_images) {
        _images = @[@"device_ancs_all",
                    @"device_ancs_sms",
                    @"device_ancs_qq",
                    @"device_ancs_wechat",
                    @"device_ancs_whatsapp",
                    
                    @"device_ancs_messenger",
                    @"device_ancs_twitter",
                    @"device_ancs_linkedin",
                    @"device_ancs_instagram",
                    @"device_ancs_facebook",
                    
                    @"device_ancs_line",
                    @"device_ancs_wechat_enterprise",
                    @"device_ancs_dingding",
                    @"device_ancs_email",
                    @"device_ancs_calendar",
                    
                    @"device_ancs_viber",
                    @"device_ancs_skype",
                    @"device_ancs_kakaotalk",
                    @"device_ancs_tumblr",
                    @"device_ancs_snapchat",
                    
                    @"device_ancs_youtube",
                    @"device_ancs_pinterset",
                    @"device_ancs_tiktok",
                    @"device_ancs_gmail",
                    @"device_ancs_other"];
    }
    return _images;
    
}

@end

