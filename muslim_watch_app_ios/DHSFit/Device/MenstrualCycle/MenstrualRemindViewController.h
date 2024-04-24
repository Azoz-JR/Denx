//
//  MenstrualRemindViewController.h
//  DHSFit
//
//  Created by DHS on 2022/11/7.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MenstrualRemindViewControllerDelegate <NSObject>

@optional

- (void)menstrualRemindChange:(BOOL)isRemindMenstrualPeriod OvulationPeriod:(BOOL)isRemindOvulationPeriod OvulationPeak:(BOOL)isRemindOvulationPeak OvulationEnd:(BOOL)isRemindOvulationEnd;

@end

@interface MenstrualRemindViewController : MWBaseController

@property (nonatomic, weak) id<MenstrualRemindViewControllerDelegate> delegate;

/// 经期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindMenstrualPeriod;
/// 排卵期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeriod;
/// 排卵高峰开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeak;
/// 排卵期结束开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationEnd;

@end

NS_ASSUME_NONNULL_END
