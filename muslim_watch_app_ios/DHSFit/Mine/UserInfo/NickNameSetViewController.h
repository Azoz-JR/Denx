//
//  NickNameSetViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NickNameSetViewControllerDelegate <NSObject>

@optional

- (void)nickNameUpdate:(NSString *)nickName;

@end

@interface NickNameSetViewController : MWBaseController

/// 代理
@property (nonatomic, weak) id<NickNameSetViewControllerDelegate> delegate;
/// 昵称
@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
