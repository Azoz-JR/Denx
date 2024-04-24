//
//  MWPickerViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MWPickerViewControllerDelegate <NSObject>

@optional

/// PickerView选中回调
/// @param row 行
/// @param component 列
/// @param viewTag Tag值
- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag;

/// 确认回调
/// @param pickerView 当前选择框
/// @param viewTag Tag值
- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag;

@end

@interface MWPickerViewController : MWBaseController

/// 代理
@property (nonatomic, weak) id<MWPickerViewControllerDelegate> delegate;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;
/// 标签
@property (nonatomic, assign) NSInteger viewTag;
/// 选中的值
@property (nonatomic, strong) NSArray *selectedRows;

/// 刷新PickerView
/// @param dataArray 数据源
- (void)reloadAllComponents:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
