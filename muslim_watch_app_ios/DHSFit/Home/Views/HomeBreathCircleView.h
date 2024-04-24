//
//  HomeBreathCircleView.h
//  DHSFit
//
//  Created by DHS on 2022/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBreathCircleView : UIView
/// 进度
@property (nonatomic, assign)CGFloat progress;
/// 呼吸
@property (nonatomic, strong) UILabel *breathLabel;

@end

NS_ASSUME_NONNULL_END
