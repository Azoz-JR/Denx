//
//  BasePickerView.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BasePickerViewDelegate <NSObject>

@optional

/// PickerView选中回调
/// @param row 行
/// @param component 列
/// @param viewTag Tag值
- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag;

/// 确认回调
/// @param pickerView 当前选择框
/// @param viewTag Tag值
- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag;

@end

@interface BasePickerView : UIView

/// 代理
@property (nonatomic, weak) id<BasePickerViewDelegate> delegate;

/// 加载视图
/// @param dataArray 数据源
/// @param unitStr 单位
/// @param viewTag Tag值
- (void)setupPickerView:(NSArray *)dataArray
                unitStr:(NSString *)unitStr
                viewTag:(NSInteger)viewTag;

/// 更新选中值
/// @param row 行
/// @param component 列
- (void)updateSelectRow:(NSInteger)row inComponent:(NSInteger)component;

/// 刷新PickerView
/// @param dataArray 数据源
- (void)reloadAllComponents:(NSArray *)dataArray;

/// 隐藏弹框
- (void)hideCustomPickerView;

@end

NS_ASSUME_NONNULL_END
