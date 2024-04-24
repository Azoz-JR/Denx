//
//  ContactEditViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ContactEditViewControllerDelegate <NSObject>

@optional

- (void)contactUpdate:(ContactSetModel *)model;

@end

@interface ContactEditViewController : MWBaseController

@property (nonatomic, weak) id<ContactEditViewControllerDelegate> delegate;

@property (nonatomic, strong) ContactSetModel *model;

@end

NS_ASSUME_NONNULL_END
