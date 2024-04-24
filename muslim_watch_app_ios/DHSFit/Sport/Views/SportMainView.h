//
//  SportMainView.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SportMainViewDelegate <NSObject>

@optional

- (void)onStartRunning;
- (void)onOutdoor;
- (void)onIndoor;

@end

@interface SportMainView : UIView
/// 代理
@property (nonatomic, weak) id<SportMainViewDelegate> delegate;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 小标题
@property (nonatomic, strong) UILabel *subTitleLabel;
/// 室内
@property (nonatomic, strong) UIButton *indoorButton;
/// 室外
@property (nonatomic, strong) UIButton *outdoorButton;
/// 背景
@property (nonatomic, strong) UIImageView *bgImageView;

@end

NS_ASSUME_NONNULL_END
