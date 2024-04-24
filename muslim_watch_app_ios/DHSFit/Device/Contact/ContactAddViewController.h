//
//  ContactAddViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ContactAddViewControllerDelegate <NSObject>

@optional

- (void)contactAdd:(ContactSetModel *)model;

@end

@interface ContactAddViewController : MWBaseController

@property (nonatomic, weak) id<ContactAddViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
