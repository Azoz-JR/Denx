//
//  PasswordUpdateView.h
//  DHSFit
//
//  Created by DHS on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PasswordUpdateViewDelegate <NSObject>

@optional

- (void)onPasswordUpdate:(NSString *)oldPassword newPassword:(NSString *)newPassword;
- (void)onTextFieldSelected:(NSInteger)viewTag;

@end

@interface PasswordUpdateView : UIView
/// 代理
@property (nonatomic, weak) id<PasswordUpdateViewDelegate> delegate;
/// 账号内容
@property (nonatomic, strong) UILabel *accountLabel;

@end

NS_ASSUME_NONNULL_END
