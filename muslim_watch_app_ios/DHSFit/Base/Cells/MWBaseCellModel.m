//
//  MWBaseCellModel.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MWBaseCellModel.h"

@implementation MWBaseCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftImage = @"";
        self.leftTitle = @"";
        self.subTitle = @"";
        self.contentTitle = @"";
        self.rightImage = @"public_cell_arrow";
        self.switchViewTag = 0;
        self.isOpen = NO;
        self.isHideSwitch = YES;
        self.isHideRedPoint = YES;
        self.isHideArrow = NO;
        self.isHideAvatar = YES;
    }
    return self;
}

@end
