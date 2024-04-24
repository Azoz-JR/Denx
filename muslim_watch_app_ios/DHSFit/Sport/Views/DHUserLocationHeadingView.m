//
//  DHUserLocationHeadingView.m
//  DHSFit
//
//  Created by DHS on 2022/9/17.
//

#import "DHUserLocationHeadingView.h"

@implementation DHUserLocationHeadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.arrowImageView.frame = self.frame;
    [self addSubview:self.arrowImageView];
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:DHImage(@"sport_main_heading")];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}

@end
