//
//  DetailSleepWeekCell.m
//  DHSFit
//
//  Created by DHS on 2022/7/9.
//

#import "DetailSleepWeekCell.h"

@interface DetailSleepWeekCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;

@end

@implementation DetailSleepWeekCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModels:(NSArray *)models {
    _models = models;
    if (!self.bgView) {
        [self setupSubViews];
    } else {
        for (int i = 0; i < models.count; i++) {
            MWBaseCellModel *cellModel = models[i];
            UILabel *subTitleLabel = [self.bgView viewWithTag:1000+i];
            subTitleLabel.text = cellModel.subTitle;
        }
    }
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = HomeColor_BlockColor;
    self.bgView.layer.cornerRadius = 10.0;
    self.bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    UIView *lastView;
    for (int i = 0; i < self.models.count; i++) {
        MWBaseCellModel *cellModel = self.models[i];
        
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.right.offset(0);
                make.height.offset(44);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.right.offset(0);
                make.height.offset(44);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_TitleColor;
        titleLabel.font = HomeFont_SubTitleFont;
        titleLabel.text = cellModel.leftTitle;
        [itemView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = HomeColor_TitleColor;
        subTitleLabel.font = HomeFont_SubTitleFont;
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        subTitleLabel.text = cellModel.subTitle;
        subTitleLabel.tag = 1000+i;
        [itemView addSubview:subTitleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HomeColor_LineColor;
        lineView.hidden = i == self.models.count-1;
        [itemView addSubview:lineView];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-HomeViewSpace_Right);
            make.width.offset(100);
            make.centerY.equalTo(itemView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.equalTo(subTitleLabel.mas_left).offset(-5);
            make.centerY.equalTo(itemView);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.bottom.offset(0);
            make.height.offset(1);
        }];
        lastView = itemView;
    }
    
}

@end
