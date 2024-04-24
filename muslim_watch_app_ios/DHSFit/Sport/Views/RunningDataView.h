//
//  RunningDataView.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunningDataView : UIView
/// 模型
@property (nonatomic, strong) DailySportModel *model;

- (void)updateTitleLabelFrame;

- (void)updateGpsRssi:(NSInteger)rssi;

@end

NS_ASSUME_NONNULL_END
