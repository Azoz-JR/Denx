//
//  CustomDialViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CustomDialViewControllerDelegate <NSObject>

@optional

- (void)customDialInstallSuccess:(CustomDialSetModel *)model;

@end

@interface CustomDialViewController : MWBaseController

@property (nonatomic, strong) CustomDialSetModel *model;

@property (nonatomic, weak) id<CustomDialViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
