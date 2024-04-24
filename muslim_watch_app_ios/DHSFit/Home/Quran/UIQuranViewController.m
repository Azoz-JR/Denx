//
//  UIQuranViewController.m
//  DHSFit
//
//  Created by DHS on 2023/4/29.
//

#import "UIQuranViewController.h"
#import "QuranViewCell.h"
#import "BRPickerView.h"
#import "LanguageManager.h"

#define MaxPage 604

@interface UIQuranViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) IBOutlet UILabel *pageNumLb;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation UIQuranViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barTintColor = [UIColor whiteColor];
    
    _isFirstLoad = YES;
    
    self.title = Lang(@"str_quran");
    
    NSInteger tSavePage = [[NSUserDefaults standardUserDefaults] integerForKey:@"KeyQuranPageNum"];
    if (tSavePage == 0){
        tSavePage = 1;
    }
    self.currentPage = tSavePage;
    
    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  self.currentPage];
        
    self.quranFlow.itemSize = CGSizeMake(kScreenWidth, kScreenWidth * 190 / 125.0);
    self.quranFlow.minimumLineSpacing = 0;
    self.quranFlow.minimumInteritemSpacing = 0;
    
    [self.quranCv registerNib:[UINib nibWithNibName:@"QuranViewCell" bundle:nil] forCellWithReuseIdentifier:@"QuranViewCell"];
    
    if ([[LanguageManager shareInstance] languageType] != LanguageTypeArabic ||
        [[LanguageManager shareInstance] languageType] != LanguageTypePersian ||
        [[LanguageManager shareInstance] languageType] != LanguageTypeURdu){ //阿拉伯语不需要反转
        self.quranCv.transform = CGAffineTransformScale(self.quranCv.transform, -1.0, 1.0);
//        self.view.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear height: %lf", self.quranCv.frame.size.height);
//    self.quranFlow.itemSize = CGSizeMake(kScreenWidth, self.quranCv.frame.size.height - 80);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear height: %lf", self.quranCv.frame.size.height);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
    self.quranFlow.itemSize = CGSizeMake(kScreenWidth, self.quranCv.frame.size.height);
    if (self.currentPage > 1 && self.isFirstLoad){
        self.isFirstLoad = NO;
        [self showItemView:self.currentPage - 1];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentPage forKey:@"KeyQuranPageNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)showPage{
//    NSArray *indexPaths = [self.quranCv indexPathsForVisibleItems];
//    NSIndexPath *tIndexPath = [indexPaths firstObject];
//
//    self.currentPage = tIndexPath.row + 1;
//
//    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  self.currentPage];
//}

- (IBAction)pageSelectButtonClick:(id)sender
{
    NSInteger tSelectIndex = 0;
    NSMutableArray *tImeiArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i <= MaxPage; ++i){
        [tImeiArr addObject:[NSString stringWithFormat:@"%d", i]];
        if (i == self.currentPage){
            tSelectIndex = i - 1;
        }
    }
    
    __weak UIQuranViewController *weakSelf = self;
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"";
    stringPickerView.dataSourceArr = tImeiArr;
    stringPickerView.selectIndex = tSelectIndex;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@ %d", resultModel.value, resultModel.index);
        weakSelf.currentPage = [resultModel.value intValue];
        weakSelf.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  weakSelf.currentPage];

        [weakSelf showItemView:resultModel.index];
    };

    [stringPickerView show];
}

- (void)showItemView:(NSInteger)page
{
//    UICollectionViewLayoutAttributes *attri = [self.quranFlow layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
//     CGPoint point = CGPointMake(attri.frame.origin.x - ([UIScreen mainScreen].bounds.size.width - self.quranFlow.itemSize.width)/2, attri.frame.origin.y);
//     [self.quranCv setContentOffset:point animated:NO];

    UICollectionViewLayoutAttributes *attributes = [self.quranCv layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    [self.quranCv setContentOffset:CGPointMake(attributes.frame.origin.x, 0) animated:NO];
    
    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  self.currentPage];
//    NSIndexPath *tIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
//    [self.quranCv setPagingEnabled:NO];
//    [self.quranCv scrollToItemAtIndexPath:tIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    [self.quranCv setPagingEnabled:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 604;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuranViewCell *tCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuranViewCell" forIndexPath:indexPath];
    
    NSString *tImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%zd-tuya", indexPath.row + 1] ofType:@"png"];
    tCell.quranIv.image = [UIImage imageWithContentsOfFile:tImagePath];
    
//    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  indexPath.row + 1];
    
    return tCell;
}

#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll x %lf", scrollView.contentOffset.x);
    NSInteger tpageNum = scrollView.contentOffset.x/kScreenWidth;
    self.currentPage = tpageNum + 1;
    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  tpageNum + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging x %lf", scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating x %lf width %lf", scrollView.contentOffset.x, kScreenWidth);

    NSInteger tpageNum = scrollView.contentOffset.x/kScreenWidth;
    self.currentPage = tpageNum + 1;
    self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  tpageNum + 1];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        NSInteger tpageNum = scrollView.contentOffset.x/kScreenWidth;
        self.currentPage = tpageNum + 1;
        self.pageNumLb.text = [NSString stringWithFormat:@"%zd/604",  tpageNum + 1];
    }
}



@end
