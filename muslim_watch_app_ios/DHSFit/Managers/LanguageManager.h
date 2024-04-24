//
//  LanguageManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeChineseSimple = 0,//简体中文
    LanguageTypeEnglish = 1,//英语
    LanguageTypeJapanese = 2,//日语
    LanguageTypeGerman = 3,//德语
    LanguageTypeFrench = 4,//法语
    LanguageTypeSpanish = 5,//西班牙语
    LanguageTypeRussian = 6,//俄语
    LanguageTypeItalian = 7,//意大利语
    LanguageTypePortuguese = 8,//葡萄牙语
    LanguageTypeTurkish = 9,//土耳其语
    LanguageTypePolish = 0x0a,//波兰语
    LanguageTypeDutch = 0x0b,//荷兰语
    LanguageTypeGreek = 0x0c,//希腊
    LanguageTypeChineseTraditional = 0x0d,//中文繁体
    LanguageTypeHebrew = 0x0e,//希伯来语
    LanguageTypeArabic = 0x0f,//阿拉伯
    LanguageTypeVietnamese = 0x10,//越南语
    LanguageTypePersian = 0x11,//波斯语
    LanguageTypeIndonesian = 0x12,//印尼语
    LanguageTypeThai = 0x13,//泰语
    LanguageTypeBurmese = 0x14,//缅甸语
    LanguageTypeHindi = 0x15,//印地语
    LanguageTypeURdu = 0x16,//乌尔都语
    LanguageTypeDanish = 0x17,//丹麦语
    LanguageTypeMalay = 0x18,//马来语
    LanguageTypeLatin = 0x19,//拉丁语
    LanguageTypeRomanian = 0x1a,//罗马尼亚语
    LanguageTypeUkrainian = 0x1b,//乌克兰语
    LanguageTypeMax
};

@interface LanguageManager : NSObject

/// 语言类型
@property (nonatomic, assign) LanguageType languageType;

- (UInt8)getJLLanguageType;

- (NSString *)getHttpLanguageType;

/// 单例
+ (__kindof LanguageManager *)shareInstance;

/// 国际化
/// @param key 键
/// @param value 值
+ (NSString *_Nullable)langWithKey:(NSString *_Nullable)key
                             value:(NSString *_Nullable)value;

/// 距离单位
+ (NSString *)distanceUnit;

/// 温度单位
+ (NSString *)tempUnit;

/// 小时单位
+ (NSString *)hourUnit;

/// 分钟单位
+ (NSString *)minuteUnit;

/// 卡路里单位
+ (NSString *)calorieUnit;

/// 身高单位
+ (NSString *)heightUnit;

/// 体重单位
+ (NSString *)weightUnit;

/// 步数单位
+ (NSString *)stepUnit;

/// 心率单位
+ (NSString *)hrUnit;

/// 血压单位
+ (NSString *)bpUnit;

/// 血氧单位
+ (NSString *)boUnit;

@end

NS_ASSUME_NONNULL_END
