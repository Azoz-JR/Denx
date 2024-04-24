//
//  HomeCellModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "HomeCellModel.h"

@implementation HomeCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = HealthDataTypeStep;
        self.leftImage = @"";
        self.leftTitle = @"";
        self.subTitle = @"";
        
        self.chartModel = [[ChartViewModel alloc] init];
    }
    return self;
}

@end
