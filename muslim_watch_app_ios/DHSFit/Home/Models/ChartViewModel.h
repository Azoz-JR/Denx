//
//  ChartViewModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartViewModel : NSObject

/// x轴标题
@property (nonatomic, strong) NSArray *xTitles;
/// y轴标题
@property (nonatomic, strong) NSArray *yTitles;
/// x轴路径
@property (nonatomic, strong) NSArray *xPaths;
/// y轴路径
@property (nonatomic, strong) NSArray *yPaths;
/// y轴路径
@property (nonatomic, strong) NSArray *yPaths1;
/// 模型
@property (nonatomic, strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
