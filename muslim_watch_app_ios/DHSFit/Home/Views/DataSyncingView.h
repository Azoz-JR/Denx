//
//  DataSyncingView.h
//  DHSFit
//
//  Created by DHS on 2022/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataSyncingView : UIView

@property (nonatomic, assign) NSInteger progress;

- (void)showSyncingView;

@end

NS_ASSUME_NONNULL_END
