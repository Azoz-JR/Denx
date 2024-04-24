//
//  BaseActionSheet.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BaseActionSheet.h"

@interface BaseActionSheet ()

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 回调Block
@property (nonatomic, copy) BaseActionSheetClickBlock alertBlock;
/// 按钮列表
@property (nonatomic, strong) NSArray *titleArray;
/// 视图高度
@property (nonatomic, assign) CGFloat viewH;

@end

@implementation BaseActionSheet

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = COLORANDALPHA(@"#000000", 0.4);
    }
    return self;
}

- (void)showWithTitles:(NSArray *)titleArray
                 block:(BaseActionSheetClickBlock)block {
     
    self.titleArray = titleArray;
    [self handleSubviews];
    self.alertBlock = block;
    [self showCustomActionSheet];
}

- (void)handleSubviews {
    
    self.viewH = kBottomHeight+150;
    self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,self.viewH);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = CGRectMake(0, 50*i, self.frame.size.width, 50);
        itemButton.tag = 100+i;
        itemButton.titleLabel.font = HomeFont_TitleFont;
        if (i == self.titleArray.count-1) {
            [itemButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        } else {
            [itemButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        }
        [itemButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:itemButton];
        
        if (i < self.titleArray.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*(i+1)-0.5, self.frame.size.width, 0.5)];
            lineView.backgroundColor = HomeColor_LineColor;
            [self.bgView addSubview:lineView];
        }
  
    }
}


#pragma mark - Subviews 视图实例化懒加载

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (void)buttonClick:(UIButton *)sender {
    
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
    [self hideCustomActionSheet];
}

- (void)showCustomActionSheet {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height-weakSelf.viewH, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCustomActionSheet {
    
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


@end
