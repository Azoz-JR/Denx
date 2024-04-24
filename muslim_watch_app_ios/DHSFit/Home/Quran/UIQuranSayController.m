//
//  UIQuranSayController.m
//  DHSFit
//
//  Created by liwei qiao on 2023/4/30.
//

#import "UIQuranSayController.h"
#import "NetworkManager.h"
#import "QuranHomeCell.h"
#import "UISayDetailController.h"

@interface UIQuranSayController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *quranSayTb;
@property (nonatomic, strong) NSMutableArray *quranSayArr;
@property (nonatomic, strong) NSString *phoneCurLang;

@end

@implementation UIQuranSayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navTitle = @"名人名言";
//    self.isHideNavRightButton = YES;
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barTintColor = [UIColor colorNamed:@"D_#F1F2F0"];
    
    self.phoneCurLang = [[LanguageManager shareInstance] getHttpLanguageType];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor blackColor]];
    
    self.title = Lang(@"str_hesn");
    
    self.quranSayArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.quranSayTb registerNib:[UINib nibWithNibName:@"QuranHomeCell" bundle:nil] forCellReuseIdentifier:@"QuranHomeCell"];
    
    //    [dict setObject:[[LanguageManager shareInstance] getHttpLanguageType] forKey:@"language"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tCellWidth = kScreenWidth - 32.0; //342x132
    CGFloat tCellHeight = tCellWidth * 200.0 /1152.0;
    return tCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuranHomeCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"QuranHomeCell" forIndexPath:indexPath];
    tCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    hadith_5_ar
    NSString *tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hadith_%d_%@", (int)indexPath.section + 1, self.phoneCurLang] ofType:@"png"];
    if (tImagePath == nil || tImagePath.length < 1){
        tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hadith_%d_%@", (int)indexPath.section + 1, @"ar"] ofType:@"png"];
    }
    tCell.homeBgIv.image = [UIImage imageWithContentsOfFile:tImagePath];
    
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UISayDetailController *sayDetailC = [[UISayDetailController alloc] initWithNibName:@"UISayDetailController" bundle:nil];
    sayDetailC.selectIndex = indexPath.section + 1;
    [self.navigationController pushViewController:sayDetailC animated:YES];
}
@end
