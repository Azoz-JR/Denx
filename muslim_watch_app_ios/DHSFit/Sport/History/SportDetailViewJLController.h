//
//  SportDetailViewJLController.h
//  DHSFit
//
//  Created by DHS on 2023/12/27.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SportDetailViewJLController : MWBaseController

/// 数据模型
@property (nonatomic, strong) DailySportModel *model;
/// 是否结束运动
@property (nonatomic, assign) BOOL isEndRunning;

@end

NS_ASSUME_NONNULL_END