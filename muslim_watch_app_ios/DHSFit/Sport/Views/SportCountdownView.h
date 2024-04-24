//
//  SportCountdownView.h
//  DHSFit
//
//  Created by DHS on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SportCountdownViewDelegate <NSObject>

@optional

- (void)countdownFinished;

@end

@interface SportCountdownView : UIView

@property (nonatomic, weak) id<SportCountdownViewDelegate> delegate;

- (void)startCount;

@end

NS_ASSUME_NONNULL_END
