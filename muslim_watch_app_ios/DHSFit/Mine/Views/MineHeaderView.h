//
//  MineHeaderView.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MineHeaderViewDelegate <NSObject>

@optional

- (void)onAvatar;

@end

@interface MineHeaderView : UIView

/// 代理
@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;
/// 模型
@property (nonatomic, strong) UserModel *model;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像
@property (nonatomic, strong) UIImage *avatarImage;

@end

NS_ASSUME_NONNULL_END
