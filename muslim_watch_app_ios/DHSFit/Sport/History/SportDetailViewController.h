//
//  SportDetailViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SportDetailViewController : MWBaseController

/// 数据模型
@property (nonatomic, strong) DailySportModel *model;
/// 是否结束运动
@property (nonatomic, assign) BOOL isEndRunning;

@end

NS_ASSUME_NONNULL_END
