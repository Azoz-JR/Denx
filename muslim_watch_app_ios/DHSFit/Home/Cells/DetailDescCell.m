//
//  DetailDescCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "DetailDescCell.h"

@interface DetailDescCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 小标题
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation DetailDescCell

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
    for (int i = 0; i < self.models.count-1; i++) {
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
        titleLabel.textColor = i == 0 ? HomeColor_TitleColor : HomeColor_TitleColor;
        titleLabel.font = i == 0 ? HomeFont_ButtonFont : HomeFont_SubTitleFont;
        titleLabel.text = cellModel.leftTitle;
        [itemView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = HomeColor_TitleColor;
        subTitleLabel.font = HomeFont_SubTitleFont;
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        subTitleLabel.text = cellModel.subTitle;
        [itemView addSubview:subTitleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HomeColor_LineColor;
        [itemView addSubview:lineView];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-HomeViewSpace_Right);
            make.width.offset(120);
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
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(12);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    MWBaseCellModel *cellModel = [self.models lastObject];
    self.bottomLabel.text = cellModel.leftTitle;
}

-(UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = HomeColor_TitleColor;
        _bottomLabel.font = HomeFont_SubTitleFont;
        _bottomLabel.numberOfLines = 0;
        [self.bgView addSubview:_bottomLabel];
    }
    
    return _bottomLabel;
}

@end

