//
//  DHSportControlModel.h
//  DHBleSDK
//
//  Created by DHS on 2023/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSportControlModel : NSObject

/// 控制类型（0.开始 1.暂停 2.继续 3.结束）
@property (nonatomic, assign) NSInteger controlType;
/// 运动类型（2.骑行 3.动感单车 4.室内跑步 5.室外跑步 6.游泳 7.走路 8.举重 9.瑜伽 10.羽毛球 11.篮球 12.跳绳 13.自由锻炼 14.足球 15.爬山 16.乒乓球）
@property (nonatomic, assign) NSInteger sportType;

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
