//
//  HomeCircleView.h
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCircleView : UIView
/// 进度
@property (nonatomic, assign)CGFloat progress;
/// 步数
@property (nonatomic, strong) UILabel *stepLabel;

@end

NS_ASSUME_NONNULL_END
