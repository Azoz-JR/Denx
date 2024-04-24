//
//  UIFoCounterController.m
//  DHSFit
//
//  Created by liwei qiao on 2023/4/30.
//

#import "UIFoCounterController.h"
#import "MWPickerViewController.h"
#import "BRPickerView.h"

@interface UIFoCounterController ()
@property (nonatomic, strong) IBOutlet UILabel *foLoopNumLb;
@property (nonatomic, strong) IBOutlet UILabel *foTotalNumLb;
@property (nonatomic, strong) IBOutlet UILabel *foCurNumLb;
@property (nonatomic, strong) IBOutlet UIImageView *foLoopIv;
@property (nonatomic, strong) IBOutlet UIView *foSwipeView;

@property (nonatomic, strong) UISwipeGestureRecognizer *recognizer;
/// 选择器
@property (nonatomic, strong) MWPickerViewController *pickerVC;

@property (nonatomic, assign) NSInteger foCurNum;
@property (nonatomic, assign) NSInteger foLoopOneTimeNum;
@property (nonatomic, assign) NSInteger foLoopNum;
@property (nonatomic, assign) NSInteger foTotalNum;
@end

@implementation UIFoCounterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = Lang(@"str_masbaha");
    
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barTintColor = [UIColor colorNamed:@"D_#F1F2F0"];
    
    self.foLoopOneTimeNum = 33;
    self.foCurNum = 1;
    self.foLoopNum = 1;
    self.foTotalNum = 1;
    
    [self showItemView];
    
    [self.navigationController setNavigationBarHidden: NO];
    
//    self.navigationController?.isNavigationBarHidden = false
    
    _recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.foSwipeView addGestureRecognizer:_recognizer];
}

- (void)showItemView
{
    self.foLoopNumLb.text = [NSString stringWithFormat:@"Loop %zd", self.foLoopNum];
    self.foTotalNumLb.text = [NSString stringWithFormat:@"%zd", self.foTotalNum];
    self.foCurNumLb.text = [NSString stringWithFormat:@"%zd/%zd", self.foCurNum, self.foLoopOneTimeNum];
}

- (void)handleSwipeFrom:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self createAnimation];
    self.foCurNum += 1;
    self.foTotalNum += 1;
    if (self.foCurNum == self.foLoopOneTimeNum){
        self.foLoopNum += 1;
        self.foCurNum = 1;
    }
    
    [self showItemView];
}

- (IBAction)currentLoopNumButtonClick{
    
    NSInteger tSelectIndex = 0;
    NSMutableArray *tImeiArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 51; ++i){
        [tImeiArr addObject:[NSString stringWithFormat:@"%d", i + 10]];
        if (i + 10 == self.foLoopOneTimeNum){
            tSelectIndex = i;
        }
    }
    
    __weak UIFoCounterController *weakSelf = self;
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"";
    stringPickerView.dataSourceArr = tImeiArr;
    stringPickerView.selectIndex = tSelectIndex;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        weakSelf.foLoopOneTimeNum = [resultModel.value intValue];
        [weakSelf showItemView];
    };

    [stringPickerView show];
}

- (void)navRightButtonClick:(UIButton *)sender
{
    self.foLoopOneTimeNum = 33;
    self.foCurNum = 1;
    self.foLoopNum = 1;
    self.foTotalNum = 1;
    
    [self showItemView];

}

- (IBAction)navRightResetButtonClick:(id)sender{
    self.foLoopOneTimeNum = 33;
    self.foCurNum = 1;
    self.foLoopNum = 1;
    self.foTotalNum = 1;
    
    [self showItemView];
}


- (void)createAnimation {
    // 1.将序列图加入数组
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 6;i++)
    {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_image_00%02ld.png",i]];
//        [imagesArray addObject:image];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Fo_%zd.png", i]];
        [imagesArray addObject:image];
    }
    // 设置序列图数组
    self.foLoopIv.animationImages = imagesArray;
    // 设置播放周期时间
    self.foLoopIv.animationDuration = 0.05*imagesArray.count;
    // 设置播放次数
    self.foLoopIv.animationRepeatCount = 1;
    // 播放动画
    [self.foLoopIv startAnimating];
}


- (void)stopAnimation{
    // 停止动画
    [self.foLoopIv stopAnimating];
    // 将图片资源进行释放
    self.foLoopIv.animationImages = nil;
    // 加载到内存中的资源要进行释放  最好用_imagesArray方式，self.imagesArray方式有的时候释放不掉；
//    _imagesArray = nil;
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
