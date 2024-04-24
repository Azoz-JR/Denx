//
//  AlarmEditViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmEditViewControllerDelegate <NSObject>

@optional

- (void)alarmUpdate:(AlarmSetModel *)model isAdd:(BOOL)isAdd;

@end

@interface AlarmEditViewController : MWBaseController

@property (nonatomic, weak) id<AlarmEditViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) AlarmSetModel *model;

@end

NS_ASSUME_NONNULL_END
