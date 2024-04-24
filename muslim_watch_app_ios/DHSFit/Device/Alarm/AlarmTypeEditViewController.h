//
//  AlarmTypeEditViewController.h
//  DHSFit
//
//  Created by DHS on 2022/7/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmTypeEditViewControllerDelegate <NSObject>

@optional

- (void)alarmTypeUpdate:(NSString *)alarmType;

@end

@interface AlarmTypeEditViewController : MWBaseController

/// 代理
@property (nonatomic, weak) id<AlarmTypeEditViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *alarmType;

@end

NS_ASSUME_NONNULL_END
