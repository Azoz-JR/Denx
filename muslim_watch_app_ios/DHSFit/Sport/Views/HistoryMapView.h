//
//  HistoryMapView.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "MkMapAppleNewView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryMapView : UIView
/// 地图
@property (nonatomic, strong) MkMapAppleNewView *mkMapView;

@end

NS_ASSUME_NONNULL_END
