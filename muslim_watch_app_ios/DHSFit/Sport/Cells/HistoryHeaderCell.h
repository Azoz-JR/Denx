//
//  HistoryHeaderCell.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryHeaderCell : UITableViewHeaderFooterView
/// 标题
@property (nonatomic, strong) UILabel *leftTitleLabel;
/// icon
@property (nonatomic, strong) UIImageView *leftImageView;

@end

NS_ASSUME_NONNULL_END
