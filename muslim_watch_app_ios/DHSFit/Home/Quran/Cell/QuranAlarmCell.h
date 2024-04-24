//
//  QuranAlarmCell.h
//  DHSFit
//
//  Created by qiao liwei on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuranAlarmCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *alarmIconIv;
@property (nonatomic, strong) IBOutlet UILabel *alarmNameLb;
@property (nonatomic, strong) IBOutlet UILabel *alarmTimeLb;
@property (nonatomic, strong) IBOutlet UISwitch *alarmSwitch;

@end

NS_ASSUME_NONNULL_END
