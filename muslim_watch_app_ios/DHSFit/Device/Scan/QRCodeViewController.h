//
//  QRCodeViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QRCodeViewControllerDelegate <NSObject>

@optional

- (void)deviceBindedSucceed:(DeviceModel *)model;

@end

@interface QRCodeViewController : MWBaseController

@property (nonatomic, weak) id<QRCodeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
