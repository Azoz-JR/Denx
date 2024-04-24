//
//  BaseSelectedView.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "BaseSelectedView.h"

@implementation BaseSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)itemButtonClick:(UIButton *)sender {
    [self updateTypeSelected:sender.tag-100];
    if ([self.delegate respondsToSelector:@selector(onTypeSelected:)]) {
        [self.delegate onTypeSelected:sender.tag-100];
    }
}

- (void)updateTypeSelected:(NSInteger)index {
    UIButton *selectedButton;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *itemButton = [self viewWithTag:i+100];
        UIColor *titleColor = i == index ? HomeColor_MainColor : HomeColor_TitleColor;
        if (itemButton) {
            [itemButton setTitleColor:titleColor forState:UIControlStateNormal];
        }
        if (i == index) {
            selectedButton = itemButton;
        }
    }
    
    UIView *lineView = [self viewWithTag:1000];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    lineView.center = CGPointMake(selectedButton.center.x, lineView.center.y);
    [UIView commitAnimations];
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    CGFloat multiplied = 1.0/self.titles.count;
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:self.titles[i] forState:UIControlStateNormal];
        UIColor *titleColor = i == 0 ? HomeColor_MainColor : HomeColor_TitleColor;
        [itemButton setTitleColor:titleColor forState:UIControlStateNormal];
        itemButton.titleLabel.font = HomeFont_TitleFont;
        itemButton.titleLabel.numberOfLines = 2;
        itemButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        itemButton.tag = 100+i;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        
        if (i == 0) {
            [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
                make.width.equalTo(self).multipliedBy(multiplied);
            }];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = HomeColor_MainColor;
            lineView.tag = 1000;
            [self addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemButton.mas_bottom).offset(-2);
                make.width.offset(40);
                make.height.offset(2);
                make.centerX.equalTo(itemButton.mas_centerX);
            }];
            
        } else {
            [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.offset(0);
                make.width.equalTo(self).multipliedBy(multiplied);
            }];
        }
        lastView = itemButton;
    }
}

@end
