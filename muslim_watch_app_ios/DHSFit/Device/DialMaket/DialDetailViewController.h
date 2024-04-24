//
//  DialDetailViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DialDetailViewControllerDelegate <NSObject>

@optional

- (void)dialUploadSuccess:(NSInteger)dialId;

@end

@interface DialDetailViewController : MWBaseController

@property (nonatomic, strong) DialMarketSetModel *model;

@property (nonatomic, weak) id<DialDetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
