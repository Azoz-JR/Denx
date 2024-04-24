//
//  BaseSelectedView.h
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseSelectedViewDelegate <NSObject>

@optional

- (void)onTypeSelected:(NSInteger)index;

@end

@interface BaseSelectedView : UIView
/// 代理
@property (nonatomic, weak) id<BaseSelectedViewDelegate> delegate;
/// 标题
@property (nonatomic, strong) NSArray *titles;

/// 更新选择下标
/// @param index 下标
- (void)updateTypeSelected:(NSInteger)index;
/// 初始化
- (void)setupSubViews;

@end

NS_ASSUME_NONNULL_END
