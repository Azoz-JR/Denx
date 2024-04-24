//
//  DeviceRssiView.m
//  DHSFit
//
//  Created by DHS on 2022/7/1.
//

#import "DeviceRssiView.h"

@interface DeviceRssiView ()

@end

@implementation DeviceRssiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIView *lastView;
    for (int i = 0; i < 4; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_LineColor;
        itemView.tag = 1000+i;
        itemView.layer.cornerRadius = 1;
        itemView.layer.masksToBounds = YES;
        [self addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(16-4);
                make.width.offset(2);
                make.height.offset(4);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(2);
                make.top.offset(16-4*(i+1));
                make.width.offset(2);
                make.height.offset(4*(i+1));
            }];
        }
        lastView = itemView;
    }
}

- (void)setStatus:(NSInteger)status {
    for (int i = 0; i < 4; i++) {
        UIView *itemView = [self viewWithTag:1000+i];
        itemView.backgroundColor = i < status ? HomeColor_MainColor : HomeColor_LineColor;
    }
}

@end
