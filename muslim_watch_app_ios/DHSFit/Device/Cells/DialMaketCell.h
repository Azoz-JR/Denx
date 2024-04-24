//
//  DialMaketCell.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DialMaketCellDelegate <NSObject>

@optional

- (void)onMoreDials:(NSString *)title Type:(NSInteger)dialType;

- (void)onDial:(DialMarketSetModel *)model;

@end

@interface DialMaketCell : UITableViewCell

@property (nonatomic, assign) NSInteger dialType;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) NSArray *dialArray;

@property (nonatomic, weak) id<DialMaketCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
