//
//  LanguageManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import "LanguageManager.h"

@implementation LanguageManager

static LanguageManager * _shared = nil;

+ (__kindof LanguageManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [LanguageManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [LanguageManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.languageType = [LanguageManager currentLanguageType];
    }
    return self;
}

- (UInt8)getJLLanguageType{
    UInt8 retLang = 0;
    switch (_languageType) {
        case LanguageTypeChineseSimple:
            retLang = 0x00;
            break;
        case LanguageTypeEnglish:
            retLang = 0x01;
            break;
        case LanguageTypeGerman:
            retLang = 0x09;
            break;
        case LanguageTypeJapanese:
            retLang = 0x10;
            break;
        case LanguageTypeFrench:
            retLang = 0x0A;
            break;
        case LanguageTypeSpanish:
            retLang = 0x05;
            break;
        case LanguageTypeItalian:
            retLang = 0x06;
            break;
        case LanguageTypePortuguese:
            retLang = 0x08;
            break;
        case LanguageTypeTurkish:
            retLang = 0x02;
            break;
        case LanguageTypeArabic:
            retLang = 0x1C;
            break;
        case LanguageTypePolish:
            retLang = 0x0C;
            break;
        case LanguageTypeThai:
            retLang = 0x16;
            break;
        case LanguageTypeVietnamese:
            retLang = 0x1B;
            break;
        case LanguageTypeHebrew:
            retLang = 0x20;
            break;
        case LanguageTypeIndonesian:
            retLang = 0x1D;
            break;
        case LanguageTypeGreek:
            retLang = 0x18;
            break;
        case LanguageTypeRussian:
            retLang = 0x04;
            break;
        case LanguageTypeDanish:{
            retLang = 0x11;
            break;
        }
        case LanguageTypeDutch:{
            retLang = 0x0B;
            break;
        }
        default:
            retLang = 0;
            break;
    }
    return retLang;
}

- (NSString *)getHttpLanguageType{
    NSString *retLang = @"zh-cn";
    switch (_languageType) {
        case LanguageTypeChineseSimple:
            retLang = @"zh-cn";
            break;
        case LanguageTypeEnglish:
            retLang = @"en";
            break;
        case LanguageTypeGerman:
            retLang = @"de";
            break;
        case LanguageTypeJapanese:
            retLang = @"ja";
            break;
        case LanguageTypeFrench:
            retLang = @"fr";
            break;
        case LanguageTypeSpanish:
            retLang = @"es";
            break;
        case LanguageTypeItalian:
            retLang = @"it";
            break;
        case LanguageTypePortuguese:
            retLang = @"pt";
            break;
        case LanguageTypeTurkish:
            retLang = @"tr";
            break;
        case LanguageTypeArabic:
            retLang = @"ar";
            break;
        case LanguageTypePolish:
            retLang = @"pl";
            break;
        case LanguageTypeThai:
            retLang = @"th";
            break;
        case LanguageTypeVietnamese:
            retLang = @"vi";
            break;
        case LanguageTypeHebrew:
            retLang = @"he";
            break;
        case LanguageTypeIndonesian:
            retLang = @"id";
            break;
        case LanguageTypeGreek:
            retLang = @"el";
            break;
        case LanguageTypePersian:
            retLang = @"fa";
            break;
        case LanguageTypeURdu:
            retLang = @"ur";
            break;
        case LanguageTypeRussian:
            retLang = @"ru";
            break;
        default:
            retLang = @"zh-cn";
            break;
    }
    return retLang;
}

+ (LanguageType)currentLanguageType {
    NSString * currentLanguage = [self getPreferredLanguage];
    if ([currentLanguage hasPrefix:@"zh-Hans"]){
        //简体中文
        return LanguageTypeChineseSimple;
    } else if ([currentLanguage hasPrefix:@"zh-Hant"]){
        //繁体中文
        return LanguageTypeChineseSimple;
    } else if ([currentLanguage hasPrefix:@"en"]){
        //英语
        return LanguageTypeEnglish;
    } else if ([currentLanguage hasPrefix:@"de"]){
        //德语
        return LanguageTypeGerman;
    }  else if ([currentLanguage hasPrefix:@"ja"]){
        //日语
        return LanguageTypeJapanese;
    } else if ([currentLanguage hasPrefix:@"fr"]){
        //法语
        return LanguageTypeFrench;
    } else if ([currentLanguage hasPrefix:@"es"]){
        //西班牙语
        return LanguageTypeSpanish;
    } else if ([currentLanguage hasPrefix:@"it"]){
        //意大利语
        return LanguageTypeItalian;
    } else if ([currentLanguage hasPrefix:@"pt"]){
        //葡萄牙语
        return LanguageTypePortuguese;
    } else if ([currentLanguage hasPrefix:@"tr"]){
        //土耳其语
        return LanguageTypeTurkish;
    } else if ([currentLanguage hasPrefix:@"ar"]){
        //阿拉伯
        return LanguageTypeArabic;
    } else if ([currentLanguage hasPrefix:@"pl"]){
        //波兰语
        return LanguageTypePolish;
    } else if ([currentLanguage hasPrefix:@"th"]){
        //泰语
        return LanguageTypeThai;
    } else if ([currentLanguage hasPrefix:@"vi"]){
        //越南语
        return LanguageTypeVietnamese;
    } else if ([currentLanguage hasPrefix:@"he"]){
       //希伯来语
       return LanguageTypeHebrew;
   } else if ([currentLanguage hasPrefix:@"id"]){
       //印尼语
       return LanguageTypeIndonesian;
   } else if ([currentLanguage hasPrefix:@"el"]){
       //希腊
       return LanguageTypeGreek;
   }
   else if ([currentLanguage hasPrefix:@"fa"]){
      //波斯语
      return LanguageTypePersian;
  }
   else if ([currentLanguage hasPrefix:@"ur"]){
      //乌尔都语
      return LanguageTypeURdu;
  }
   else if ([currentLanguage hasPrefix:@"ru"]){
      //俄罗斯
      return LanguageTypeRussian;
  }
    
    return LanguageTypeChineseSimple;
}


+ (NSString*)getPreferredLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages firstObject];
    return preferredLang;
}

+ (NSString *_Nullable)langWithKey:(NSString *_Nullable)key
                             value:(NSString *_Nullable)value {
    return NSLocalizedStringWithDefaultValue(key,@"ChineseSimple",[NSBundle mainBundle],value,nil);
}

+ (NSString *)distanceUnit {
    if (ImperialUnit) {
        return @"mi";
    }
    return @"km";
}

+ (NSString *)tempUnit {
    if (FahrenheitUnit) {
        return @"℉";
    }
    return @"℃";
}

+ (NSString *)hourUnit {
    return @"h";
}

+ (NSString *)minuteUnit {
    return @"min";
}

+ (NSString *)calorieUnit {
    return @"kcal";
}

+ (NSString *)heightUnit {
    if (ImperialUnit) {
        return @"inch";
    }
    return @"cm";
}

+ (NSString *)weightUnit {
    if (ImperialUnit) {
        return @"lbs";
    }
    return @"kg";
}

+ (NSString *)stepUnit {
    return Lang(@"str_unit_step");
}

+ (NSString *)hrUnit {
    return @"bpm";
}

+ (NSString *)bpUnit {
    return @"mmHg";
}

+ (NSString *)boUnit {
    return @"%";
}

@end
