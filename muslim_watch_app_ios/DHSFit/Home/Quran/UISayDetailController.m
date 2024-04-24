//
//  UISayDetailController.m
//  DHSFit
//
//  Created by qiao liwei on 2023/5/22.
//

#import "UISayDetailController.h"
#import "QuranHomeCell.h"

@interface UISayDetailController ()
@property (nonatomic, strong) IBOutlet UIImageView *selectImageIv;
@property (nonatomic, strong) IBOutlet UITableView *quranSayTb;
@property (nonatomic, strong) NSString *phoneCurLang;
@property (nonatomic, strong) NSArray *pageNumArray;

@end

@implementation UISayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barTintColor = [UIColor whiteColor];
    
    self.phoneCurLang = [[LanguageManager shareInstance] getHttpLanguageType];
    
    self.pageNumArray = @[@(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(3), @(2)];
    if ([self.phoneCurLang isEqualToString:@"en"]){
        self.pageNumArray = @[@(2), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(2), @(1), @(6), @(4)];
    }
    else if ([self.phoneCurLang isEqualToString:@"es"]){
        self.pageNumArray = @[@(2), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(2), @(1), @(7), @(5)];
    }
    else if ([self.phoneCurLang isEqualToString:@"fr"]){
        self.pageNumArray = @[@(2), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(2), @(1), @(6), @(4)];
    }
    else if ([self.phoneCurLang isEqualToString:@"id"]){
        self.pageNumArray = @[@(3), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(3), @(1), @(9), @(5)];
    }
    else if ([self.phoneCurLang isEqualToString:@"ru"]){
        self.pageNumArray = @[@(3), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(2), @(1), @(6), @(5)];
    }
    else if ([self.phoneCurLang isEqualToString:@"tr"]){
        self.pageNumArray = @[@(2), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(2), @(1), @(5), @(3)];
    }
    else{
        self.phoneCurLang = @"ar";
    }
    
    
    [self.quranSayTb registerNib:[UINib nibWithNibName:@"QuranHomeCell" bundle:nil] forCellReuseIdentifier:@"QuranHomeCell"];
    
    //    hadith_5_ar
    NSString *tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hadith_%d_%@", (int)self.selectIndex, self.phoneCurLang] ofType:@"png"];
    if (tImagePath == nil || tImagePath.length < 1){
        tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hadith_%d_%@", (int)self.selectIndex, @"ar"] ofType:@"png"];
    }
    self.selectImageIv.image = [UIImage imageWithContentsOfFile:tImagePath];
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
    return [self.pageNumArray[self.selectIndex - 1] intValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tCellWidth = kScreenWidth - 32.0; //342x132
    CGFloat tCellHeight = tCellWidth * 2208.0 /1242.0;
    return tCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuranHomeCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"QuranHomeCell" forIndexPath:indexPath];
    tCell.selectionStyle = UITableViewCellSelectionStyleNone;

    //hadith_detail_5_1_tr
    NSString *tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hadith_detail_%zd_%d_%@", self.selectIndex, (int)indexPath.section + 1, self.phoneCurLang] ofType:@"png"];
    tCell.homeBgIv.image = [UIImage imageWithContentsOfFile:tImagePath];
    
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
