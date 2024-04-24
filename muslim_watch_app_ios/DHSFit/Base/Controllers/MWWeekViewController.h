//
//  MWWeekViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MWWeekViewControllerDelegate <NSObject>

@optional

- (void)repeatsUpdate:(NSArray *)repeats;

@end

@interface MWWeekViewController : MWBaseController

/// 代理
@property (nonatomic, weak) id<MWWeekViewControllerDelegate> delegate;
/// 选中的值
@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectIndexs;

@end

NS_ASSUME_NONNULL_END
