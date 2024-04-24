//
//  CustomDialCell.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomDialCellDelegate <NSObject>

@optional

- (void)onCustomDial;

@end

@interface CustomDialCell : UITableViewCell

@property (nonatomic, weak) id<CustomDialCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *leftImageView;

+ (UIImage*)imageFromColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
