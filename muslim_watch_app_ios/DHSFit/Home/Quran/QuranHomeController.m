//
//  QuranHomeController.m
//  DHSFit
//
//  Created by DHS on 2023/5/7.
//

#import "QuranHomeController.h"
#import "UIQuranViewController.h"
#import "UIQuranSayController.h"
#import "UIFoCounterController.h"
#import "UIQuranAlarmController.h"
#import "UICompassController.h"
#import "QuranHomeCell.h"

@interface QuranHomeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *homeTb;
@property (nonatomic, strong) NSString *phoneCurLang;
@end

@implementation QuranHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hbd_barHidden = YES;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barTintColor = [UIColor clearColor];

    self.phoneCurLang = [[LanguageManager shareInstance] getHttpLanguageType];

    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor blackColor]];
        
    [self.homeTb registerNib:[UINib nibWithNibName:@"QuranHomeCell" bundle:nil] forCellReuseIdentifier:@"QuranHomeCell"];
}

#pragma mark- 古兰经 点击事件
- (IBAction)quranButtonClick{
    UIQuranViewController *vc = [[UIQuranViewController alloc] initWithNibName:@"UIQuranViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)quranSayButtonClick{
    UIQuranSayController *quranSayC = [[UIQuranSayController alloc] initWithNibName:@"UIQuranSayController" bundle:nil];
    quranSayC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quranSayC animated:YES];
}

- (IBAction)quranCounterButtonClick{
    UIFoCounterController *counterC = [[UIFoCounterController alloc] initWithNibName:@"UIFoCounterController" bundle:nil];
    counterC.hidesBottomBarWhenPushed = YES;
    //[counterC setNavRightImage:@"Fo_item_reset"];
    [self.navigationController pushViewController:counterC animated:YES];
}

#pragma mark- UITableViewDelegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tCellWidth = kScreenWidth - 32.0; //342x132
    CGFloat tCellHeight = tCellWidth * 901.0 /2341.0;
    return tCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuranHomeCell *tCell = (QuranHomeCell *)[tableView dequeueReusableCellWithIdentifier:@"QuranHomeCell"];
    tCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"muslim_home_%02d_%@", (int)indexPath.section + 1, self.phoneCurLang] ofType:@"jpg"];
    if (tImagePath == nil || tImagePath.length < 1){
        tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"muslim_home_%02d_%@", (int)indexPath.section + 1, @"ar"] ofType:@"jpg"];
    }
    tCell.homeBgIv.image = [UIImage imageWithContentsOfFile:tImagePath];
    
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        UIQuranViewController *vc = [[UIQuranViewController alloc] initWithNibName:@"UIQuranViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1){
        UIFoCounterController *counterC = [[UIFoCounterController alloc] initWithNibName:@"UIFoCounterController" bundle:nil];
        counterC.hidesBottomBarWhenPushed = YES;
        //[counterC setNavRightImage:@"Fo_item_reset"];
        [self.navigationController pushViewController:counterC animated:YES];
    }
    else if (indexPath.section == 2){
        UIQuranSayController *quranSayC = [[UIQuranSayController alloc] initWithNibName:@"UIQuranSayController" bundle:nil];
        quranSayC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:quranSayC animated:YES];
    }
    else if (indexPath.section == 3){
        UICompassController *tCompassC = [[UICompassController alloc] initWithNibName:@"UICompassController" bundle:nil];
        tCompassC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tCompassC animated:YES];
    }
    else{
        UIQuranAlarmController *quranAlarmC = [[UIQuranAlarmController alloc] initWithNibName:@"UIQuranAlarmController" bundle:nil];
        quranAlarmC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:quranAlarmC animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
