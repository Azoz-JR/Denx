//
//  DHUnitSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHUnitSetModel : NSObject

/// 语言（0.简体中文 1.英语 2.日语 3.德语 4.法语 5.西班牙语 6.俄语 7.意大利语 8.葡萄牙语 9.土耳其语）
/// /// 20230603添加 0x0a波兰语 --- 0X1B乌克兰语
@property (nonatomic, assign) NSInteger language;
/// 公英制（ 0.公制  1.英制）
@property (nonatomic, assign) NSInteger distanceUnit;
/// 温度单位（ 0.摄氏度 1.华氏度）
@property (nonatomic, assign) NSInteger tempUnit;
/// 时间制式（ 0.24小时制  1.12小时制）
@property (nonatomic, assign) NSInteger timeformat;

@end

NS_ASSUME_NONNULL_END
