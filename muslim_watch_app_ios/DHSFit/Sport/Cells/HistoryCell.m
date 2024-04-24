//
//  HistoryCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "HistoryCell.h"

@interface HistoryCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIView *dataView;

@property (nonatomic, strong) NSArray *images;

@end

@implementation HistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailySportModel *)model {
    _model = model;
    
    NSString *imageStr = model.isDevice ? @"sport_record_watch" : @"sport_record_mobile";
    self.rightImageView.image = DHImage(imageStr);
    
    if (model.isJLRunType){
        self.leftImageView.image = DHImage([RunningManager recordTypeJLImage:model.type]);
        
        if (model.type == BLE_ACTIVITY_WALKING ||
            model.type == BLE_ACTIVITY_CLIMBING ||
            model.type == BLE_ACTIVITY_CYCLING ||
            model.type == BLE_ACTIVITY_INDOOR ||
            model.type == BLE_ACTIVITY_RUNNING) {
            
            self.leftTitleLabel.text = [NSString stringWithFormat:@"%@  %.02f%@", [RunningManager runningTypeJLTitle:model.type], DistanceValue(model.distance), DistanceUnit];
        
        } else {
            self.leftTitleLabel.text = [RunningManager runningTypeJLTitle:model.type];
        }
    }
    else{
        self.leftImageView.image = DHImage([RunningManager recordTypeImage:model.type]);
        
        if (model.type == SportTypeWalk ||
            model.type == SportTypeClimb ||
            model.type == SportTypeRide ||
            model.type == SportTypeRunIndoor ||
            model.type == SportTypeRunOutdoor) {
            
            self.leftTitleLabel.text = [NSString stringWithFormat:@"%@  %.02f%@", [RunningManager runningTypeTitle:model.type], DistanceValue(model.distance), DistanceUnit];
        } else {
            self.leftTitleLabel.text = [RunningManager runningTypeTitle:model.type];
        }
    }

    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.timestamp integerValue]];
    self.bottomLabel.text = [date dateToStringFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    for (int i = 0; i < self.images.count; i++) {
        UILabel *itemLabel = [self.dataView viewWithTag:1000+i];
        if (i == 0) {
            itemLabel.text = [NSString stringWithFormat:@"%.01f%@", KcalValue(model.calorie), CalorieUnit];
        } else if (i == 1) {
            itemLabel.text = [RunningManager transformDuration:model.duration];
        } else {
            NSInteger avgPace;
            UIImageView *itemPaceIcon = [self.dataView viewWithTag:3000+i];

            if (self.model.isJLRunType){
                if (self.model.viewType < 4){ //有配速
                    avgPace = self.model.pace;
                    if (ImperialUnit){
                        avgPace = 1.609*avgPace;
                    }
                    itemLabel.text = [NSString stringWithFormat:@"%ld'%02ld\"",(long)avgPace/60,(long)avgPace%60];
                }
                else{ //显示心率
                    itemPaceIcon.image = [UIImage imageNamed:@"sport_main_heart"];
                    itemLabel.text = [NSString stringWithFormat:@"%ld%@",self.model.heartAve, HrUnit];
                }
            }
            else{
                if (ImperialUnit) {
                    avgPace = model.distance > 0 ? 1609.0*model.duration/model.distance : 0;
                } else {
                    avgPace = model.distance > 0 ? 1000.0*model.duration/model.distance : 0;
                }
                itemLabel.text = [NSString stringWithFormat:@"%ld'%02ld\"", (long)avgPace/60, (long)avgPace%60];
            }
        }
    }
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.height.offset(70);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        //        make.top.offset(25);
        make.width.offset(200);
        make.bottom.equalTo(self.bottomLabel.mas_top);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.centerY.equalTo(self.leftTitleLabel);
        
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.leftTitleLabel);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.centerY.equalTo(self.bgView);
    }];

    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.right.offset(0);
        make.height.offset(30);
        make.bottom.offset(-20);
    }];
    
    CGFloat multiplied = 1.0/self.images.count;
    UIView *lastView;
    for (int i = 0; i < self.images.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        [self.dataView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.left.offset(0);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        }
        
        UIImageView *itemImageView = [[UIImageView alloc] init];
        itemImageView.image = DHImage(self.images[i]);
        itemImageView.tag = 3000+i;
        [itemView addSubview:itemImageView];
        
        UILabel *itemLabel = [[UILabel alloc]init];
        itemLabel.textColor = HomeColor_TitleColor;
        itemLabel.font = HomeFont_SubTitleFont;
        itemLabel.text = @"";
        itemLabel.tag = 1000+i;
        [itemView addSubview:itemLabel];
        
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(itemView);
        }];
        
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemImageView.mas_right).offset(5);
            make.centerY.equalTo(itemView);
        }];
        
        lastView = itemView;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_ButtonFont;
        _leftTitleLabel.text = @"";
        _leftTitleLabel.numberOfLines = 0;
        _leftTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bgView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = HomeColor_TitleColor;
        _subTitleLabel.font = HomeFont_SubTitleFont;
        _subTitleLabel.text = @"";
        [self.bgView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.textColor = HomeColor_TitleColor;
        _bottomLabel.font = HomeFont_SubTitleFont;
        _bottomLabel.text = @"";
        [self.bgView addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_dataView];
    }
    return _dataView;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"sport_main_calories",
                    @"sport_main_duration",
                    @"sport_main_pace"];
    }
    return _images;
}

@end
