//
//  AlarmTimePickerView.h
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmTimePickerViewDelegate <NSObject>

@optional

/// PickerView滚动代理
/// @param row 行
/// @param component 列
/// @param viewTag Tag值
- (void)pickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag;

@end


@interface AlarmTimePickerView : UIView

/// 选择器
@property (nonatomic, strong) UIPickerView *picker;
/// 代理
@property (nonatomic, weak) id<AlarmTimePickerViewDelegate> delegate;


/// 加载视图
/// @param array 数据源
/// @param unitStr 单位
/// @param viewTag Tag值
- (void)loadPickerViewWithArray:(NSArray *)array
                        unitStr:(NSString *)unitStr
                        viewTag:(NSInteger)viewTag;

/// 更新选中值
/// @param row 行
/// @param component 列
- (void)updateSelectRow:(NSInteger)row inComponent:(NSInteger)component;


/// 刷新PickerView
/// @param dataArray 数据源
- (void)reloadAllComponents:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
