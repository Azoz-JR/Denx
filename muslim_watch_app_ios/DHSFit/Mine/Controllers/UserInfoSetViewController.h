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

- (void)userModelChange;

@end

@interface UserInfoSetViewController : MWBaseController

@property (nonatomic, weak) id<UserInfoSetViewControllerDelegate> delegate;

@property (nonatomic, strong) UserModel *model;

@end

NS_ASSUME_NONNULL_END
