//
//  PlaceholderTextView.h
//  DHSFit
//
//  Created by DHS on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderTextView : UITextView

/// 提示语
@property (nonatomic, strong, nullable) UILabel * placeHolderLabel;
/// 提示语
@property (nonatomic, copy) NSString * placeholder;
/// 提示语颜色
@property (nonatomic, strong) UIColor * placeholderColor;

@end

NS_ASSUME_NONNULL_END
