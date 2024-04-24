//
//  DeviceDialCell.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceDialCellDelegate <NSObject>

@optional

- (void)onMoreDials;

- (void)onDial:(nullable DialMarketSetModel *)model;

@end

@interface DeviceDialCell : UITableViewCell

@property (nonatomic, strong) NSArray *dialArray;

@property (nonatomic, weak) id<DeviceDialCellDelegate> delegate;

- (void)setupSubViews;

@end

NS_ASSUME_NONNULL_END
