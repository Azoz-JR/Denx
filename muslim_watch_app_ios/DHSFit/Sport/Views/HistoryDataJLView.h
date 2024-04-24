//
//  HistoryDataJLView.h
//  DHSFit
//
//  Created by DHS on 2023/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryDataJLView : UIView
/// 模型
@property (nonatomic, strong) DailySportModel *model;


- (instancetype)initWithFrame:(CGRect)frame model:(DailySportModel *)sportModel;
@end

NS_ASSUME_NONNULL_END
