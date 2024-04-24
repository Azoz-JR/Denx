//
//  DeviceInfoCell.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceInfoCellDelegate <NSObject>

@optional

- (void)onConfirmOTA:(BOOL)isHideRedPoint;

@end

@interface DeviceInfoCell : UITableViewCell

@property (nonatomic, weak) id<DeviceInfoCellDelegate> delegate;


- (void)updateDeviceImageView:(NSString *)imageUrl;

- (void)updateCell;

- (void)updateRedPoint:(NSString *)onlineVersion;

@end

NS_ASSUME_NONNULL_END
