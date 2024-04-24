//
//  PhotosSelectedView.h
//  DHSFit
//
//  Created by DHS on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotosSelectedViewDelegate <NSObject>

@optional

- (void)onDeletedPhoto:(NSInteger)viewTag;

- (void)onAddPhoto;

@end

@interface PhotosSelectedView : UIView

/// 代理
@property (nonatomic, weak) id<PhotosSelectedViewDelegate> delegate;
/// 刷新视图
/// @param dataArray 数据源
- (void)updateView:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
