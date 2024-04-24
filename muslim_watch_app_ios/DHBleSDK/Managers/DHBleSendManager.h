//
//  DHBleSendManager.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DHBleCommandDelegate.h"
#import "DHFunctionInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DHBleCallbackBlock)(int code, id data);

typedef void(^DHBleSyncingCallbackBlock)(int code, int progress, id data);

typedef void(^DHBleFileSyncingCallbackBlock)(int code, CGFloat progress, id data);

@interface DHBleSendManager : NSObject

/// 单例
+ (__kindof DHBleSendManager *)shareInstance;

#pragma mark - 获取类

/// 获取固件版本信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock firmwareVersionGetBlock;
/// 获取电量信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock batteryGetBlock;
/// 获取绑定信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock bindInfoGetBlock;
/// 获取功能表block
@property (nonatomic, copy, nullable) DHBleCallbackBlock functionGetBlock;
/// 获取表盘信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock dialInfoGetBlock;

/// 获取ANCSblock
@property (nonatomic, copy, nullable) DHBleCallbackBlock ancsGetBlock;
/// 获取久坐提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock sedentaryGetBlock;
/// 获取喝水提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock drinkingGetBlock;
/// 获取提醒模式block
@property (nonatomic, copy, nullable) DHBleCallbackBlock reminderModeGetBlock;
/// 获取闹钟提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock alarmsGetBlock;

/// 获取抬腕亮屏block
@property (nonatomic, copy, nullable) DHBleCallbackBlock gestureGetBlock;
/// 获取亮屏时长block
@property (nonatomic, copy, nullable) DHBleCallbackBlock brightTimeGetBlock;
/// 获取心率监测block
@property (nonatomic, copy, nullable) DHBleCallbackBlock heartRateModeGetBlock;
/// 获取勿扰模式block
@property (nonatomic, copy, nullable) DHBleCallbackBlock disturbModeGetBlock;
/// 获取MAC地址block
@property (nonatomic, copy, nullable) DHBleCallbackBlock macAddressGetBlock;

/// 获取经典蓝牙block
@property (nonatomic, copy, nullable) DHBleCallbackBlock classicBleGetBlock;
/// 获取本地表盘block
@property (nonatomic, copy, nullable) DHBleCallbackBlock localDialGetBlock;
/// 获取Ota状态block
@property (nonatomic, copy, nullable) DHBleCallbackBlock otaInfoGetBlock;
/// 获取呼吸训练block
@property (nonatomic, copy, nullable) DHBleCallbackBlock breathGetBlock;
/// 获取自定义表盘信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock customDialGetBlock;
/// 获取生理周期block
@property (nonatomic, copy, nullable) DHBleCallbackBlock menstrualCycleGetBlock;

/// 获取祈祷闹钟block
@property (nonatomic, copy, nullable) DHBleCallbackBlock prayAlarmGetBlock;

#pragma mark - 设置类

/// 设置绑定信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock bindSetBlock;
/// 设置时间block
@property (nonatomic, copy, nullable) DHBleCallbackBlock timeSetBlock;
/// 设置单位block
@property (nonatomic, copy, nullable) DHBleCallbackBlock unitSetBlock;
/// 设置ANCSblock
@property (nonatomic, copy, nullable) DHBleCallbackBlock ancsSetBlock;
/// 设置闹钟提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock alarmSetBlock;
/// 设置祈祷闹钟提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock prayAlarmSetBlock;
/// 设置亮屏时长block
@property (nonatomic, copy, nullable) DHBleCallbackBlock brightTimeSetBlock;
/// 设置通讯录block
@property (nonatomic, copy, nullable) DHBleCallbackBlock contactSetBlock;
/// 设置久坐提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock sedentarySetBlock;
/// 设置喝水提醒block
@property (nonatomic, copy, nullable) DHBleCallbackBlock drinkingSetBlock;
/// 设置提醒模式block
@property (nonatomic, copy, nullable) DHBleCallbackBlock reminderModeSetBlock;
/// 设置抬腕亮屏block
@property (nonatomic, copy, nullable) DHBleCallbackBlock gestureSetBlock;
/// 设置心率监测block
@property (nonatomic, copy, nullable) DHBleCallbackBlock heartRateModeSetBlock;
/// 设置勿扰模式block
@property (nonatomic, copy, nullable) DHBleCallbackBlock disturbModeSetBlock;
/// 设置个人信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock userInfoSetBlock;
/// 设置二维码block
@property (nonatomic, copy, nullable) DHBleCallbackBlock qrCodeSetBlock;
/// 设置运动目标block
@property (nonatomic, copy, nullable) DHBleCallbackBlock sportGoalSetBlock;
/// 设置天气block
@property (nonatomic, copy, nullable) DHBleCallbackBlock weatherSetBlock;
/// 设置呼吸block
@property (nonatomic, copy, nullable) DHBleCallbackBlock breathSetBlock;
/// 设置生理周期block
@property (nonatomic, copy, nullable) DHBleCallbackBlock menstrualCycleSetBlock;
/// 设置定位信息block
@property (nonatomic, copy, nullable) DHBleCallbackBlock locationSetBlock;

#pragma mark - 控制类

/// 拍照控制（0.关闭 1.打开 2.拍照）block
@property (nonatomic, copy, nullable) DHBleCallbackBlock cameraControlBlock;
/// 开始寻找设备block
@property (nonatomic, copy, nullable) DHBleCallbackBlock findDeviceControlBlock;
/// 结束寻找手机block
@property (nonatomic, copy, nullable) DHBleCallbackBlock findPhoneControlBlock;
/// 设备控制（0.重启 1.关机 2.恢复出厂设置）block
@property (nonatomic, copy, nullable) DHBleCallbackBlock deviceControlBlock;
/// 解绑设备block
@property (nonatomic, copy, nullable) DHBleCallbackBlock unbindBlock;
/// 运动控制（0.开始 1.暂停 2.继续 3.结束）block
@property (nonatomic, copy, nullable) DHBleCallbackBlock sportControlBlock;
/// 运动交换数据block
@property (nonatomic, copy, nullable) DHBleCallbackBlock sportDataControlBlock;
/// APP当前状态block
@property (nonatomic, copy, nullable) DHBleCallbackBlock appstatusControlBlock;
/// 表盘传输开始
@property (nonatomic, copy, nullable) DHBleCallbackBlock fileSyncingStartBlock;

#pragma mark - 表盘传输类
/// 表盘传输
@property (nonatomic, copy, nullable) DHBleFileSyncingCallbackBlock dialSyncingBlock;
#pragma mark - 文件传输类
/// 文件传输
@property (nonatomic, copy, nullable) DHBleFileSyncingCallbackBlock fileSyncingBlock;
#pragma mark - 轨迹同步类
/// 轨迹同步
@property (nonatomic, copy, nullable) DHBleFileSyncingCallbackBlock mapSyncingBlock;
/// 缩略图同步
@property (nonatomic, copy, nullable) DHBleFileSyncingCallbackBlock thumbnailSyncingBlock;

#pragma mark - 自动同步数据类
/// 同步数据
@property (nonatomic, copy, nullable) DHBleSyncingCallbackBlock dataSyncingBlock;

#pragma mark - 手动同步数据类

/// 查询需要同步的数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock checkDataSyncingBlock;
/// 同步计步数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock stepSyncingBlock;
/// 同步睡眠数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock sleepSyncingBlock;
/// 同步心率数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock hrSyncingBlock;
/// 同步血压数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock bpSyncingBlock;
/// 同步血氧数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock boSyncingBlock;
/// 同步体温数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock tempSyncingBlock;
/// 同步呼吸数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock breathSyncingBlock;
/// 同步运动数据
@property (nonatomic, copy, nullable) DHBleCallbackBlock sportSyncingBlock;

@property (nonatomic, assign) CGFloat connectInterval;
/// 单包长度
@property (nonatomic, assign) NSInteger onePackageLength;
/// 流水号
@property (nonatomic, assign) NSInteger commandSerial;
/// 外围设备
@property (nonatomic, strong, nullable) CBPeripheral *peripheral;
/// 命令服务特征
@property (nonatomic, strong, nullable) CBCharacteristic *writeCharacteristic;
/// 数据发送列表
@property (nonatomic, strong) NSMutableArray *sendDataList;
/// 数据发送列表
@property (nonatomic, strong) NSMutableArray *sendTimeList;
/// 数据发送列表
@property (nonatomic, strong) NSMutableArray *sendSerialList;
/// 数据发送列表
@property (nonatomic, strong) NSMutableArray *sendCommandList;
/// 当前处理的蓝牙数据返回commondkey
@property (nonatomic, copy) NSString *currentCommondId;

#pragma mark - 同步数据
/// 正在同步数据
@property (nonatomic, assign) BOOL isDataSyncing;
/// 同步历史数据进度
@property (nonatomic, assign) int dataSyncProgress;
/// 同步历史数据间隔
@property (nonatomic, assign) int dataSyncInterval;

#pragma mark - 表盘传输

/// 正在传输表盘
@property (nonatomic, assign) BOOL isDialSyncing;
/// 表盘传输进度
@property (nonatomic, assign) CGFloat dialSyncProgress;
/// 传输表盘序号
@property (nonatomic, assign) NSInteger dialSyncIndex;
/// 传输表盘个数
@property (nonatomic, assign) NSInteger dialSyncCount;
/// 表盘数据包数组
@property (nonatomic, strong) NSMutableArray *dialSyncArray;

@property (nonatomic, assign) UInt32 dialSyncDataIndex; //表盘同步偏移量;
@property (nonatomic, assign) UInt32 dialSyncDataLen; //表盘同步数据总长度;

#pragma mark - 文件传输

/// 正在传输文件
@property (nonatomic, assign) BOOL isFileSyncing;
/// 文件传输进度
@property (nonatomic, assign) CGFloat fileSyncProgress;
/// 文件传输序号
@property (nonatomic, assign) NSInteger fileSyncIndex;
/// 文件传输个数
@property (nonatomic, assign) NSInteger fileSyncCount;
/// 文件传输数据包数组
@property (nonatomic, strong) NSMutableArray *fileSyncArray;

#pragma mark - 轨迹同步

/// 正在传输轨迹
@property (nonatomic, assign) BOOL isMapSyncing;
/// 轨迹同步进度
@property (nonatomic, assign) CGFloat mapSyncProgress;
/// 轨迹同步序号
@property (nonatomic, assign) NSInteger mapSyncIndex;
/// 轨迹同步个数
@property (nonatomic, assign) NSInteger mapSyncCount;
/// 轨迹同步数据包数组
@property (nonatomic, strong) NSMutableArray *mapSyncArray;

#pragma mark - 缩略图同步

/// 正在传输缩略图
@property (nonatomic, assign) BOOL isThumbnailSyncing;
/// 缩略图同步进度
@property (nonatomic, assign) CGFloat thumbnailSyncProgress;
/// 缩略图同步序号
@property (nonatomic, assign) NSInteger thumbnailSyncIndex;
/// 缩略图同步个数
@property (nonatomic, assign) NSInteger thumbnailSyncCount;
/// 缩略图同步数据包数组
@property (nonatomic, strong) NSMutableArray *thumbnailSyncArray;

/// 设备回复代理
@property (nonatomic, weak) id<DHBleCommandDelegate> commandDelegate;

/// 获取同步进度实际间隔
- (int)getSyncInterval;

/// 删除某个指令
/// @param command 指令key
/// @param isTimeOut 是否超时
-(void)removeAllProcessDictionaryForCommand:(NSString *)command
                                  isTimeOut:(BOOL)isTimeOut;

/// APP通用应答
/// @param serial 流水号
/// @param command 指令key
-(void)feedbackDeviceSerial:(NSInteger)serial command:(NSInteger)command;

/// 清除指令列表
-(void)clearSendDatalist;

- (void)sendJieLiTest;

/// 发送指令
/// @param payload 内容
/// @param writeType 类型
/// @param repeats 是否重发
- (void)sendCommandWithPayload:(NSString *)payload
                     writeType:(DHBleCommandType)writeType
                       repeats:(BOOL)repeats;

/// 分包发送指令
/// @param data 内容
/// @param index 包序号
/// @param count 总包数
/// @param writeType 类型
/// @param repeats 是否重发
- (void)sendCommandWithData:(NSData *)data
                          index:(NSInteger)index
                          count:(NSInteger)count
                     writeType:(DHBleCommandType)writeType
                        repeats:(BOOL)repeats;

/// 发送指令
/// @param writeType 类型
/// @param repeats 是否重发
- (void)sendCommand:(DHBleCommandType)writeType
            repeats:(BOOL)repeats;

/// 发送指令
/// @param data 内容
/// @param writeType 类型
/// @param repeats 是否重发
- (void)sendCommandWithData:(NSData *)data
                  writeType:(DHBleCommandType)writeType
                    repeats:(BOOL)repeats;

/// 同步计步数据
- (void)startStepSyncing;
/// 同步睡眠数据
- (void)startSleepSyncing;
/// 同步心率数据
- (void)startHeartRateSyncing;
/// 同步血压数据
- (void)startBloodPressureSyncing;

/// 同步血氧数据
- (void)startBloodOxygenSyncing;
/// 同步体温数据
- (void)startTempSyncing;
/// 同步呼吸数据
- (void)startBreathSyncing;
/// 同步运动数据
- (void)startSportSyncing;

- (void)startJLPressSyncing;

#pragma mark - 表盘传输

/// 杰里开始表盘传输
- (void)jlStartSendDialData:(BleKey)bleKey;
- (void)jlStartSendUIData:(BleKey)bleKey;

/// 开始表盘传输
- (void)startSendDialData;
/// 表盘传输失败
/// @param message 错误信息
- (void)dialSyncingFailed:(NSString *)message;
/// 表盘传输完成
- (void)dialSyncingFinished;

- (void)dialSyncingStart;
- (void)dialSyncingOutgoing;
- (void)jlDialSyncingOutgoing:(BleKey)blekey;

#pragma mark - 文件传输

/// 开始文件传输
- (void)startSendFileData;
/// 文件传输失败
/// @param message 错误信息
- (void)fileSyncingFailed:(NSString *)message;
/// 文件传输完成
- (void)fileSyncingFinished;

- (void)fileSyncingOutgoing;
- (void)fileSyncingStart;

#pragma mark - 轨迹同步

/// 开始轨迹传输
- (void)startSendMapData;
/// 轨迹同步失败
/// @param message 错误信息
- (void)mapSyncingFailed:(NSString *)message;
/// 轨迹同步完成
- (void)mapSyncingFinished;

- (void)mapSyncingStart;
- (void)mapSyncingOutgoing;

#pragma mark - 缩略图同步

/// 开始缩略图传输
- (void)startSendThumbnailData;
/// 缩略图同步失败
/// @param message 错误信息
- (void)thumbnailSyncingFailed:(NSString *)message;
/// 缩略图同步完成
- (void)thumbnailSyncingFinished;

- (void)thumbnailSyncingStart;
- (void)thumbnailSyncingOutgoing;


- (void)startCustomDialSyncing:(NSString *)payload;


#pragma mark- 杰里平台协议方法
- (void)sendCommand:(BleCommand)cmdType 
            keyType:(BleKey)keyType
             opType:(BleKeyFlag)opType
              value:(NSData *)value;

- (void)sendCommandNow:(BleCommand)cmdType
               keyType:(BleKey)keyType
                opType:(BleKeyFlag)opType
                 value:(NSData *)value;

- (void)sendAck:(NSData *)ackData;


- (void)sendFileData:(NSData *)fileData fileIndex:(UInt32)fileIndex key:(BleKey)key;

- (void)jlPopQueue;
- (void)jlHandleNextPacket;
- (void)jlCleanQueue;

@end

NS_ASSUME_NONNULL_END
