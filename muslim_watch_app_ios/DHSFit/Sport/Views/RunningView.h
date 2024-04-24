//
//  RunningView.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RunningViewDelegate <NSObject>

@optional

- (void)onContinue;
- (void)onPause;
- (void)onEnd;
- (void)onMap;
- (void)onSettings;

@end

@interface RunningView : UIView
/// 代理
@property (nonatomic, weak) id<RunningViewDelegate> delegate;
/// 模型
@property (nonatomic, strong) DailySportModel *model;
/// 地图
@property (nonatomic, strong) UIButton *mapButton;
/// 左标题
@property (nonatomic, strong) UILabel *leftTitleLabel;
/// 左按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 右按钮
@property (nonatomic, strong) UIButton *rightButton;
/// 自动暂停
- (void)autoPauseClick;
/// 自动继续
- (void)autoContinueClick;

@end

NS_ASSUME_NONNULL_END
