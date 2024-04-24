//
//  OTAViewController.h
//  DHSFit
//
//  Created by DHS on 2022/7/19.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTAViewControllerDelegate <NSObject>

@optional

- (void)deviceOtaSucceed:(OnlineFirmwareVersionModel *)model;

@end

@interface OTAViewController : MWBaseController

@property (nonatomic, weak) id<OTAViewControllerDelegate> delegate;

@property (nonatomic, strong) OnlineFirmwareVersionModel *onlieModel;

@end

NS_ASSUME_NONNULL_END
