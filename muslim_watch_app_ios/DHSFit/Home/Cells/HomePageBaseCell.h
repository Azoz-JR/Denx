//
//  HomePageBaseCell.h
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import <UIKit/UIKit.h>
#import "HomeCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageBaseCell : UICollectionViewCell

/// 数据模型
@property (nonatomic, strong) HomeCellModel *model;
/// 左icon
@property (nonatomic, strong) UIImageView *leftImageView;
/// 左标题
@property (nonatomic, strong) UILabel *leftTitleLabel;
/// 数值
@property (nonatomic, strong) UILabel *valueLabel;
/// 图表
@property (nonatomic, strong) UIView *chartView;
/// 无数据
@property (nonatomic, strong) UIView *noDataView;

/// 更新睡眠图表
/// @param chartModel 模型
- (void)updateSleepChartView:(ChartViewModel *)chartModel;
/// 更新心率图表
/// @param chartModel 模型
- (void)updateHrChartView:(ChartViewModel *)chartModel;
/// 更新血压图表
/// @param chartModel 模型
- (void)updateBpChartView:(ChartViewModel *)chartModel;
/// 更新血氧图表
/// @param chartModel 模型
- (void)updateBoChartView:(ChartViewModel *)chartModel;
/// 更新体温图表
/// @param chartModel 模型
- (void)updateTempChartView:(ChartViewModel *)chartModel;
/// 更新呼吸图表
/// @param dataModel 模型
- (void)updateBreathChartView:(DailyBreathModel *)dataModel;

@end

NS_ASSUME_NONNULL_END
