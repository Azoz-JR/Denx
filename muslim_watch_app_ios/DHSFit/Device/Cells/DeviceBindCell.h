//
//  DeviceBindCell.h
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceBindCellDelegate <NSObject>

@optional

- (void)onBind;

@end

@interface DeviceBindCell : UITableViewCell

@property (nonatomic, weak) id<DeviceBindCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
