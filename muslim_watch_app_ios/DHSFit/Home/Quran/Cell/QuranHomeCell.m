//
//  QuranHomeCell.m
//  DHSFit
//
//  Created by qiao liwei on 2023/5/22.
//

#import "QuranHomeCell.h"

@implementation QuranHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.homeBgIv.layer.cornerRadius = 10.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
