//
//  QuranViewCell.m
//  DHSFit
//
//  Created by DHS on 2023/4/29.
//

#import "QuranViewCell.h"

@implementation QuranViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[LanguageManager shareInstance] languageType] != LanguageTypeArabic ||
        [[LanguageManager shareInstance] languageType] != LanguageTypePersian ||
        [[LanguageManager shareInstance] languageType] != LanguageTypeURdu){ //阿拉伯语不需要反转
        self.quranIv.transform = CGAffineTransformScale(self.quranIv.transform, -1.0, 1.0);
    }

}

@end
