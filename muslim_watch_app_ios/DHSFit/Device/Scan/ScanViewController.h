//
//  ScanViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScanViewControllerDelegate <NSObject>

@optional

- (void)deviceBindedSucceed:(DeviceModel *)model;

@end

@interface ScanViewController : MWBaseController

@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
