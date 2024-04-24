//
//  PhotosSelectedView.m
//  DHSFit
//
//  Created by DHS on 2022/7/19.
//

#import "PhotosSelectedView.h"

@interface PhotosSelectedView ()

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PhotosSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.dataArray = [NSMutableArray array];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {

    CGFloat imageW = (kScreenWidth-30-80)/3.0;
    UIView *lastView;
    for (int i = 0; i < self.dataArray.count+1; i++) {
        UIImageView *itemImageView = [[UIImageView alloc] init];
        
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        itemImageView.layer.masksToBounds = YES;
        [self addSubview:itemImageView];
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setImage:DHImage(@"mine_feedback_delete") forState:UIControlStateNormal];
        itemButton.tag = 100+i;
        [itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        
        if (i == self.dataArray.count) {
            itemButton.hidden = YES;
            itemImageView.image = DHImage(@"mine_feedback_add");
            itemImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
            [itemImageView addGestureRecognizer:tap];
        } else {
            itemImageView.image = self.dataArray[i];
        }
        
        if (i == 0) {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.bottom.offset(0);
                make.height.width.offset(imageW);
            }];
        } else {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(20);
                make.bottom.offset(0);
                make.height.width.offset(imageW);
            }];
        }
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemImageView.mas_right).offset(-10);
            make.bottom.equalTo(itemImageView.mas_top).offset(10);
            make.height.width.offset(20);
        }];
        
        lastView = itemImageView;
    }

}

- (void)imageViewTap:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(onAddPhoto)]) {
        [self.delegate onAddPhoto];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onDeletedPhoto:)]) {
        [self.delegate onDeletedPhoto:sender.tag];
    }
}



- (void)updateView:(NSArray *)dataArray {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (dataArray.count) {
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    } else {
        self.dataArray = [NSMutableArray array];
    }
    [self setupSubViews];
    
}

@end
