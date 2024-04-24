//
//  HomeCellModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCellModel : NSObject

/// 健康类型
@property (nonatomic, assign) HealthDataType cellType;
/// 左icon
@property (nonatomic, copy) NSString *leftImage;
/// 左标题
@property (nonatomic, copy) NSString *leftTitle;
/// 小标题
@property (nonatomic, copy) NSString *subTitle;
/// 原始模型
@property (nonatomic, strong) id dataModel;
/// 图表模型
@property (nonatomic, strong) ChartViewModel *chartModel;

@end

NS_ASSUME_NONNULL_END
