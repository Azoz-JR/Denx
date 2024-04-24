//
//  MWBaseTableCell.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import <UIKit/UIKit.h>
#import "MWBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWBaseTableCell : UITableViewCell

/// 数据模型
@property (nonatomic, strong) MWBaseCellModel *model;
/// 头像
@property (nonatomic, strong) UIImageView *avatarView;
/// 开关
@property (nonatomic, strong) UISwitch *switchView;
/// 左标题
@property (nonatomic, strong) UILabel *leftTitleLabel;
/// 是否头部
@property (nonatomic, assign) BOOL isHeader;

@end

NS_ASSUME_NONNULL_END
