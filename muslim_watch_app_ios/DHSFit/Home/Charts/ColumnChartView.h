//
//  ColumnChartView.h
//  DHSFit
//
//  Created by DHS on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColumnChartView : UIView
/// 健康类型
@property (nonatomic, assign) HealthDataType cellType;
/// 主色调
@property (nonatomic, strong) UIColor *mainColor;
/// 是否可点击
@property (nonatomic, assign) BOOL isCanClick;
/// 模型
@property (nonatomic, strong) ChartViewModel *chartModel;

@end

NS_ASSUME_NONNULL_END
