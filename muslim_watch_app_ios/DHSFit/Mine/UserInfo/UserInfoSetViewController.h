//
//  UserInfoSetViewController.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserInfoSetViewControllerDelegate <NSObject>

@optional

- (void)nickNameUpdate:(NSString *)nickName;

- (void)avatarUpdate:(UIImage *)avatarImage;

@end

@interface UserInfoSetViewController : MWBaseController

@property (nonatomic, weak) id<UserInfoSetViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
