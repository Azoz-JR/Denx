//
//  NickNameSetViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NickNameSetViewControllerDelegate <NSObject>

@optional

- (void)nickNameDidChange:(NSString *)nickName;

@end

@interface NickNameSetViewController : BaseViewController

/// 代理
@property (nonatomic, weak) id<NickNameSetViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
