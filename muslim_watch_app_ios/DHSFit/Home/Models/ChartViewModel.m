//
//  ChartViewModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/14.
//

#import "ChartViewModel.h"

@implementation ChartViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.xTitles = [NSArray array];
        self.yTitles = [NSArray array];
        self.xPaths = [NSArray array];
        self.yPaths = [NSArray array];
        self.yPaths1 = [NSArray array];
        self.dataArray = [NSArray array];
        
    }
    return self;
}

@end
