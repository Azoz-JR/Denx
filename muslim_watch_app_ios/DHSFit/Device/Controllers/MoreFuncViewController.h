//
//  MoreFuncViewController.h
//  DHSFit
//
//  Created by DHS on 2023/1/5.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MoreFuncViewControllerDelegate <NSObject>

@optional

- (void)restoreSuccess;

@end

@interface MoreFuncViewController : MWBaseController

/// 代理
@property (nonatomic, weak) id<MoreFuncViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
