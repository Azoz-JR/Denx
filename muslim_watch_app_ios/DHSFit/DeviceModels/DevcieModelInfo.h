//
//  DevcieModelInfo.h
//  DHSFit
//
//  Created by DHS on 2023/4/29.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevcieModelInfo : DHBaseModel
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString *customizeDialShowUrl;
@property (nonatomic, assign) NSInteger defaultCustomizeDialFlag;
@property (nonatomic, strong) NSString *defaultCustomizeDialUrl;
@property (nonatomic, strong) NSString *showUrl;
@property (nonatomic, assign) NSInteger thumbWidth;
@property (nonatomic, assign) NSInteger thumbHeight;
@end

NS_ASSUME_NONNULL_END
