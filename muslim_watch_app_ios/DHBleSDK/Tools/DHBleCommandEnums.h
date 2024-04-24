//
//  DHBleCommandEnums.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#ifndef DHBleCommandEnums_h
#define DHBleCommandEnums_h

//指令类型
typedef enum : NSUInteger {
    
#pragma mark - 获取类
    //固件版本获取
    DHBleCommandTypeFirmwareVersionGet = 0x00,
    //设备电量获取
    DHBleCommandTypeBatteryGet,
    //绑定信息获取
    DHBleCommandTypeBindInfoGet,
    //功能表获取
    DHBleCommandTypeFunctionGet,
    //表盘信息获取
    DHBleCommandTypeDialInfoGet,
    
    //ANCS获取
    DHBleCommandTypeAncsGet = 0x05,
    //久坐提醒获取
    DHBleCommandTypeSedentaryGet,
    //喝水提醒获取
    DHBleCommandTypeDrinkingGet,
    //提醒模式获取
    DHBleCommandTypeReminderModeGet,
    //闹钟获取
    DHBleCommandTypeAlarmGet,
    
    //抬腕亮屏获取
    DHBleCommandTypeGestureGet = 0x0A,
    //亮屏时长获取
    DHBleCommandTypeBrightTimeGet,
    //心率监测获取
    DHBleCommandTypeHeartRateModeGet,
    //勿扰模式获取
    DHBleCommandTypeDisturbModeGet,
    //MAC地址获取
    DHBleCommandTypeMacAddressGet,
    
    //经典蓝牙信息获取
    DHBleCommandTypeClassicBleGet = 0x0F,
    //本地表盘获取
    DHBleCommandTypeLocalDialGet,
    //OTA状态获取
    DHBleCommandTypeOtaInfoGet,
    //呼吸训练获取
    DHBleCommandTypeBreathGet,
    //自定义表盘信息获取
    DHBleCommandTypeCustomDialGet,
    
    //生理周期获取
    DHBleCommandTypeMenstrualCycleGet = 0x14,
    
    //祈祷闹钟获取
    DHBleCommandTypePrayAlarmGet = 0x15,
    
#pragma mark - 设置类
    //绑定信息设置
    DHBleCommandTypeBindSet = 0x20,
    //时间设置
    DHBleCommandTypeTimeSet,
    //单开关设置
    DHBleCommandTypeSwitchSet,
    //ANCS设置
    DHBleCommandTypeAncsSet,
    //单位设置：语言、公英制、温度、时间制式等
    DHBleCommandTypeUnitSet,
    
    //久坐提醒设置
    DHBleCommandTypeSedentarySet = 0x25,
    //喝水提醒设置
    DHBleCommandTypeDrinkingSet,
    //提醒模式设置
    DHBleCommandTypeReminderModeSet,
    //闹钟设置
    DHBleCommandTypeAlarmSet,
    //抬腕亮屏设置
    DHBleCommandTypeGestureSet,
    
    //亮屏时长设置
    DHBleCommandTypeBrightTimeSet = 0x2A,
    //心率监测设置
    DHBleCommandTypeHeartRateModeSet,
    //勿扰模式设置
    DHBleCommandTypeDisturbModeSet,
    //通讯录设置
    DHBleCommandTypeContactSet,
    //个人信息设置
    DHBleCommandTypeUserInfoSet,
    
    //二维码设置
    DHBleCommandTypeQRCodeSet = 0x2F,
    //运动目标设置
    DHBleCommandTypeSportGoalSet,
    //天气设置
    DHBleCommandTypeWeatherSet,
    //呼吸训练设置
    DHBleCommandTypeBreathSet = 0x33,
    //生理周期设置
    DHBleCommandTypeMenstrualCycleSet,
    //定位信息设置
    DHBleCommandTypeLocationSet = 0x36,
    //设置祈祷闹钟
    DHBleCommandTypePrayAlarmSet = 0x37,
    
#pragma mark - 控制类
    //拍照控制：关闭、打开、拍照
    DHBleCommandTypeCameraControl = 0x40,
    //寻找设备：开始
    DHBleCommandTypeFindDeviceBeginControl,
    //结束寻找手机
    DHBleCommandTypeFindPhoneEndControl,
    //设备控制：重启、关机、恢复出厂设置
    DHBleCommandTypeDeviceControl,
    //解绑设备
    DHBleCommandTypeUnbindControl,

    //运动控制：开始、暂停、继续、结束
    DHBleCommandTypeSportControl = 0x45,
    //运动交换数据
    DHBleCommandTypeSportDataControl,
    //APP当前状态
    DHBleCommandTypeAppStatusControl = 0x48,

#pragma mark - 设备广播类
    //电量信息广播
    DHBleCommandTypeBatteryNotification = 0x60,
    //健康数据广播
    DHBleCommandTypeHealthDataNotification,
    //久坐提醒广播
    DHBleCommandTypeSedentaryNotification,
    //喝水提醒广播
    DHBleCommandTypeDrinkingNotification,
    //提醒模式广播
    DHBleCommandTypeReminderModeNotification,
    
    //闹钟广播
    DHBleCommandTypeAlarmNotification = 0x65,
    //抬腕亮屏广播
    DHBleCommandTypeGestureNotification,
    //亮屏时长广播
    DHBleCommandTypeBrightTimeNotification,
    //心率监测广播
    DHBleCommandTypeHeartRateModeNotification,
    //勿扰模式广播
    DHBleCommandTypeDisturbModeNotification,
    
    //拍照广播
    DHBleCommandTypeCameraNotification = 0x6A,
    //寻找手机广播
    DHBleCommandTypeFindPhoneNotification,
    //mtu广播
    DHBleCommandTypeMtuNotification,
    //时间同步广播
    DHBleCommandTypeTimeSyncNotification = 0x6F,
    //蓝牙连接间隔
    DHBleCommandTypeConnectIntervalNotification = 0x72,
    
    //文件传输状态广播
    DHBleCommandTypeFileStatusNotification = 0x7A,
    //表盘传输状态广播
    DHBleCommandTypeDialStatusNotification = 0x7B,
    //轨迹同步状态广播
    DHBleCommandTypeMapStatusNotification = 0x7C,
    //缩略图同步状态广播
    DHBleCommandTypeThumbnailStatusNotification = 0x7D,
    //定位信息请求广播
    DHBleCommandTypeLocationNotification = 0x7F,
    //祈祷闹钟广播
    DHBleCommandTypePrayAlarmNotification = 0x90,
    
#pragma mark - 文件传输类
    //表盘传输
    DHBleCommandTypeDialSyncing = 0x80,
    //文件开始传输
    DHBleCommandTypeFileSyncingStart = 0x81,
    //缩略图同步
    DHBleCommandTypeThumbnailSyncing = 0x82,
    //文件传输
    DHBleCommandTypeFileSyncing = 0x84,
    //轨迹同步
    DHBleCommandTypeMapSyncing = 0x85,
    
#pragma mark - 同步数据类
    
    //同步健康数据
    DHBleCommandTypeDataSyncing = 0xA0,
    //同步计步数据
    DHBleCommandTypeStepSyncing,
    //同步睡眠数据
    DHBleCommandTypeSleepSyncing,
    //同步心率数据
    DHBleCommandTypeHeartRateSyncing,
    //同步血压数据
    DHBleCommandTypeBloodPressureSyncing,
    
    //同步血氧数据
    DHBleCommandTypeBloodOxygenSyncing = 0xA5,
    //同步体温数据
    DHBleCommandTypeTempSyncing,
    //同步呼吸数据
    DHBleCommandTypeBreathSyncing,
    //同步运动数据
    DHBleCommandTypeSportSyncing,
    
    //同步设备日志
    DHBleCommandTypeLogSyncing = 0xAF,

} DHBleCommandType;

typedef enum : UInt8 {
    BLE_COMMAND_UPDATE = 0x01,
    BLE_COMMAND_SET,
    BLE_COMMAND_CONNECT,
    BLE_COMMAND_PUSH,
    BLE_COMMAND_DATA,
    BLE_COMMAND_CONTROL,
    BLE_COMMAND_IO,
    JLBLECmd_MAX
} BleCommand;

typedef enum : UInt8 {
    BLE_KEY_FLAG_UPDATE = 0x00, //改(写)操作，指令版本0
    BLE_KEY_FLAG_READ = 0x10, //查(读)操作，指令版本0
    BLE_KEY_FLAG_READ_CONTINUE = 0x11,
    BLE_KEY_FLAG_CREATE = 0x20, //增操作，指令版本0
    BLE_KEY_FLAG_DELETE = 0x30, //删操作，指令版本0
    BLE_KEY_FLAG_NONE
} BleKeyFlag;

typedef enum : UInt16 {
    // UPDATE
     BLE_KEY_OTA = 0x0101,
     BLE_KEY_XMODEM = 0x0102,

     // SET
     BLE_KEY_TIME = 0x0201,
     BLE_KEY_TIME_ZONE = 0x0202,
     BLE_KEY_POWER = 0x0203,
     BLE_KEY_FIRMWARE_VERSION = 0x0204,
     BLE_KEY_BLE_ADDRESS = 0x0205,
     BLE_KEY_USER_PROFILE = 0x0206,
     BLE_KEY_STEP_GOAL = 0x0207,
     BLE_KEY_BACK_LIGHT = 0x0208,
     BLE_KEY_SEDENTARINESS = 0x0209,
     BLE_KEY_NO_DISTURB_RANGE = 0x020A,
     BLE_KEY_VIBRATION = 0x020B,
     BLE_KEY_GESTURE_WAKE = 0x020C,
     BLE_KEY_HR_ASSIST_SLEEP = 0x020D,
     BLE_KEY_HOUR_SYSTEM = 0x020E,
     BLE_KEY_LANGUAGE = 0x020F,
     BLE_KEY_ALARM = 0x0210,
     BLE_KEY_UNIT = 0x0211,
     BLE_KEY_COACHING = 0x0212,
     BLE_KEY_FIND_PHONE = 0x0213,
     BLE_KEY_NOTIFICATION_REMINDER = 0x0214,
     BLE_KEY_ANTI_LOST = 0x0215,
     BLE_KEY_HR_MONITORING = 0x0216,
     BLE_KEY_UI_PACK_VERSION = 0x0217,
     BLE_KEY_LANGUAGE_PACK_VERSION = 0x0218,
     BLE_KEY_SLEEP_QUALITY = 0x0219,
     BLE_KEY_GIRL_CARE = 0x021A,
     BLE_KEY_TEMPERATURE_DETECTING = 0x021B,
     BLE_KEY_TEMPERATURE_UNIT = 0x021D,
     BLE_KEY_DATE_FORMAT = 0x21E,
     BLE_KEY_AGPS_PREREQUISITE = 0x0220, // AGPS前置条件，对应BleAgpsPrerequisite
     BLE_KEY_DRINK_WATER_SITE = 0x0221,
     BLE_KEY_SHUT_DOWN = 0x0222,         // APP下发关机命令
     BLE_KEY_APP_WORKOUT_DATA = 0x0223,
     BLE_KEY_APP_REAL_TIME_HR_DATA = 0x0224,
     BLE_KEY_SPO2_MONITORING = 0x0225, //血氧定时监测设置
     BLE_KEY_HANDWASHING_SITE = 0x0226,
     // 设备支持外置多表盘时，因为IO协议的限制，无法包含表盘id信息，所以发送表盘文件前先发送该指令提前告知表盘id
     BLE_KEY_WATCHFACE_ID = 0x0227,
     BLE_KEY_IBEACON_SWITCH = 0x0228,
     BLE_KEY_QR_BASECONVERT = 0x0229,
     BLE_KEY_APP_REAL_TIME_TEMPERATURE_DATA = 0x0230,
     BLE_KEY_APP_REAL_TIME_BP_DATA = 0x0231,
     BLE_KEY_APP_TEMPERATURE_CALIBRATION = 0x0232,   /// 温度标定
     BLE_KEY_PARENTAL_CONTROL = 0x0233,
     BLE_KEY_FIND_WATCH = 0x0234,//找手表命令
     BLE_KEY_WATCH_PASSWORD = 0x0235,//设置手表密码锁
     BLE_KEY_WATCH_MEASURE = 0x0236,//设置手表进入测量界面
     BLE_KEY_POWER_SAVING_MODE = 0x0237,//设置手表进入省电模式
     BLE_KEY_ALCOHOL_THRESHOLD = 0x0238,//酒精测量阈值
     BLE_KEY_CAL_GOAL = 0x0239,
     BLE_KEY_DISTANCE_GOAL = 0x023A,
     BLE_KEY_SLEEP_GOAL = 0x023B,
     BLE_KEY_LOVETAP_CONTACTS = 0x023C,
     BLE_KEY_MEDICINE = 0x023D,
     BLE_KEY_WATCH_INFO = 0x023E,
     BLE_KEY_HEARTRATE_ALERT = 0x023F,
     BLE_KEY_DYNAMIC_SLEEP_TIME = 0x0240,
     BLE_KEY_SCREEN_SAVER_SET = 0x0241,
     BLE_KEY_BT_NAME = 0x0242,
     BLE_KEY_MEDICINE_2 = 0x0246,
 #ifdef PRODUCT_S1PRO_V2
     BLE_KEY_MATCH_SET = 0x0247,
 #endif
     BLE_KEY_WATCH_STATUS_INFO = 0x0249,
 #ifdef MID_ALIOS_UPAY_SUPPORT
     BLE_KEY_UPAY_INFO = 0x024A,
 #endif
     BLE_KEY_VOICE_DATA = 0x024B,
     BLE_KEY_WORSHIP_ANGLE = 0x024C,
     BLE_KEY_APP_REAL_TIME_ACTIVITY_DATA = 0x024D,
     BLE_KEY_APP_REAL_TIME_BLOOD_OXYGEN_DATA = 0x024E,
     BLE_KEY_APP_REAL_TIME_STRESS_DATA = 0x024F,
     BLE_KEY_APP_CHATGPT_TYPE = 0x0250,
     BLE_KEY_APP_CHATGPT_ANSWER = 0x0251,
     BLE_KEY_APP_PRAYER_TIME_SYNC = 0x0252,  //祈祷闹钟
     REALTIME_LOG = 0x02F9,
     BLE_KEY_GSENSOR_OUTPUT = 0x02FA, // 1: 开启GSensor输出；2: 关闭GSensor输出
     BLE_KEY_GSENSOR_RAW = 0x02FB, // G-Sensor原始数据
     BLE_KEY_MOTION_DETECT = 0x02FC, // G-Sensor动作检测数据，n组√(x1 - x0)² + (y1 - y0)² + (z1 - z0)²，带符号16位整数
     BLE_KEY_LOCATION_GGA = 0x02FD, // 设备定位GGA数据
     BLE_KEY_RAW_SLEEP = 0x02FE, // 睡眠算法的原始数据
     BLE_KEY_NO_DISTURB_GLOBAL = 0x02FF,

     // CONNECT
     BLE_KEY_IDENTITY = 0x0301,     // 身份，代表绑定的意思
     BLE_KEY_SESSION = 0x0302,      // 会话，代表登陆的意思
     BLE_KEY_REQUEST_PAIR = 0x0303, // 请求配对

     // PUSH
     BLE_KEY_NOTIFICATION = 0x0401,
     BLE_KEY_MUSIC_CONTROL = 0x0402,
     BLE_KEY_SCHEDULE = 0x0403,
     BLE_KEY_WEATHER_REALTIME = 0x0404,
     BLE_KEY_WEATHER_FORECAST = 0x0405,
     BLE_KEY_HID_COMMAND = 0x0406,
     BLE_KEY_WORLD_CLOCK = 0x0407, // 世界时钟
     BLE_KEY_STOCK = 0x0408, // 股票
     BLE_KEY_SMS_QUICK_REPLY_CONTENT = 0x0409, // 短信快捷回复内容
     BLE_KEY_NOTIFICATION2 = 0x040A,
     BLE_KEY_NEWSFEED = 0x040B,
     BLE_KEY_WEATHER_REALTIME2 = 0x040C, //新的实时天气协议
     BLE_KEY_WEATHER_FORECAST2 = 0x040D, //新的天气预报协议

     // DATA
     BLE_KEY_DATA_ALL = 0x05ff, // 实际协议中并没有该指令，该指令只是用来同步所有数据
     BLE_KEY_ACTIVITY_REALTIME = 0x0501,
     BLE_KEY_ACTIVITY = 0x0502,
     BLE_KEY_HEART_RATE = 0x0503,
     BLE_KEY_BLOOD_PRESSURE = 0x0504,
     BLE_KEY_SLEEP = 0x0505,
     BLE_KEY_WORKOUT = 0x0506,
     BLE_KEY_LOCATION = 0x0507,
     BLE_KEY_TEMPERATURE = 0x0508,
     BLE_KEY_BLOOD_OXYGEN = 0x0509,
     BLE_KEY_HRV = 0x050A,
     BLE_KEY_LOG = 0x050B,
     BLE_KEY_STRESS = 0x050D,
     BLE_KEY_WORKOUT2 = 0x050E,

 #ifdef PRODUCT_S1PRO
     BLE_KEY_MATCH_DATA = 0x050F,
 #endif
     BLE_KEY_BLOOD_SUGAR = 0x0510,
 #ifdef PRODUCT_S1PRO_V2
     BLE_KEY_MATCH_DATA2 = 0x0516,//比赛数据 v2版本
 #endif
     // CONTROL
     BLE_KEY_CAMERA = 0x0601,
     BLE_KEY_REQUEST_LOCATION = 0x0602,
     BLE_KEY_CALL = 0x0603,
     BLE_KEY_APP_WORKOUT_CONTROL = 0x0604,
     BLE_KEY_CLASSIC_BLUETOOTH_CONTROL = 0x0605,
     BLE_KEY_IBEACON_CONTROL = 0x0606,
     BLE_KEY_SMS_QUICK_REPLY = 0x0607,
     BLE_KEY_LOVETAP = 0x0608,

     // IO
     BLE_KEY_WATCH_FACE = 0x0701,
     BLE_KEY_AGPS_FILE = 0x0702,
     BLE_KEY_FONT_FILE = 0x0703,
     BLE_KEY_CONTACT = 0x0704,
     BLE_KEY_UI_FILE = 0x0705,
     BLE_KEY_UPLOAD_FILE = 0x0706,
     BLE_KEY_LANGUAGE_FILE = 0x0707,
     BLE_KEY_BRAND_INFO_FILE = 0x0708,
     BLE_KEY_QR_CODE_FILE = 0x0709,
     BLE_KEY_THIRD_APP_DATA = 0x070A, //第三方应用的数据
     BLE_KEY_ALL_BIN_DATA = 0x070B, //大包升级(所有bin组合)
     BLE_KEY_NONE = 0xffff
} BleKey;

typedef enum {
    BLE_ACTIVITY_START_INDEX = 7,        // 枚举值开始标记
    BLE_ACTIVITY_RUNNING = 7,            // 跑步           10 MET/70Kg/60分钟/700千卡
    BLE_ACTIVITY_INDOOR = 8,             // 跑步机          7.3 MET/70Kg/60分钟/511千卡
    BLE_ACTIVITY_OUTDOOR = 9,            // 户外跑步运动    未查到
    BLE_ACTIVITY_CYCLING = 10,           // 骑行            8 MET/70Kg/60分钟/560千卡
    BLE_ACTIVITY_SWIMMING = 11,          // 游泳            6 MET/70Kg/60分钟/420千卡
    BLE_ACTIVITY_WALKING = 12,           // 步行，健走      2.5 MET/70Kg/60分钟/175千卡
    BLE_ACTIVITY_CLIMBING = 13,          // 爬山            6.7 MET/70Kg/60分钟/469千卡
    BLE_ACTIVITY_YOGA = 14,              // 瑜伽            2.5 MET/70Kg/60分钟/175千卡
    BLE_ACTIVITY_SPINNING = 15,          // 动感单车        12 MET/70Kg/60分钟/840千卡
    BLE_ACTIVITY_BASKETBALL = 16,        // 篮球            6 MET/70Kg/60分钟/420千卡
    BLE_ACTIVITY_FOOTBALL = 17,          // 足球            7 MET/70Kg/60分钟/490千卡
    BLE_ACTIVITY_BADMINTON = 18,         // 羽毛球          4.5 MET/70Kg/60分钟/315千卡
    BLE_ACTIVITY_MARATHON = 19,          // 马拉松          未查到
    BLE_ACTIVITY_INDOOR_WALK = 20,       // 室内步行        2.5 MET/70Kg/60分钟/175千卡
    BLE_ACTIVITY_FREE_TRAINING = 21,     // 自由锻炼        未查到
    BLE_ACTIVITY_TRACK_AND_FIELD = 22,   // 田径            //竞赛
    BLE_ACTIVITY_WEIGHTTRANNING = 23,    // 力量训练        未查到
    BLE_ACTIVITY_WEIGHTLIFTING = 24,     // 举重            3 MET/70Kg/60分钟/210千卡
    BLE_ACTIVITY_BOXING = 25,            // 拳击            12 MET/70Kg/60分钟/840千卡 boxing
    BLE_ACTIVITY_JUMP_ROPE = 26,         // 跳绳            10 MET/70Kg/60分钟/700千卡
    BLE_ACTIVITY_CLIMB_STAIRS = 27,      // 爬楼梯          8 MET/70Kg/60分钟/560千卡
    BLE_ACTIVITY_SKI = 28,               // 滑雪            6.3 MET/70Kg/60分钟/441千卡
    BLE_ACTIVITY_SKATE = 29,             // 滑冰            7 MET/70Kg/60分钟/490千卡
    BLE_ACTIVITY_ROLLER_SKATING = 30,    // 轮滑            11.9 MET/70Kg/60分钟/490千卡
    BLE_ACTIVITY_CYCLING_INDOOR = 31,    // 室内骑行        //竞赛
    BLE_ACTIVITY_HULA_HOOP = 32,         // 呼啦圈          5 MET/70Kg/60分钟/350千卡
    BLE_ACTIVITY_GOLF = 33,              // 高尔夫          4.5 MET/70Kg/60分钟/315千卡
    BLE_ACTIVITY_BASEBALL = 34,          // 棒球            5 MET/70Kg/60分钟/350千卡
    BLE_ACTIVITY_DANCE = 35,             // 舞蹈            4.5 MET/70Kg/60分钟/315千卡
    BLE_ACTIVITY_PING_PONG = 36,         // 乒乓球          4 MET/70Kg/60分钟/280千卡
    BLE_ACTIVITY_HOCKEY = 37,            // 曲棍球          7 MET/70Kg/60分钟/490千卡
    BLE_ACTIVITY_PILATES = 38,           // 普拉提          3.5 MET/70Kg/60分钟/245千卡
    BLE_ACTIVITY_TAEKWONDO = 39,         // 跆拳道          10 MET/70Kg/60分钟/700千卡
    BLE_ACTIVITY_HANDBALL = 40,          // 手球            12 MET/70Kg/60分钟/840千卡
    BLE_ACTIVITY_DANCE_STREET = 41,      // 街舞            7.8 MET/70Kg/60分钟/548千卡
    BLE_ACTIVITY_VOLLEYBALL = 42,        // 排球            8 MET/70Kg/60分钟/560千卡
    BLE_ACTIVITY_TENNIS = 43,            // 网球            7 MET/70Kg/60分钟/490千卡
    BLE_ACTIVITY_DARTS = 44,             // 飞镖            2.5 MET/70Kg/60分钟/175千卡
    BLE_ACTIVITY_GYMNASTICS = 45,        // 体操            4.7 MET/70Kg/60分钟/327千卡
    BLE_ACTIVITY_STEPPING = 46,          // 踏步            4 MET/70Kg/60分钟/280千卡
    BLE_ACTIVITY_ELLIPTICAL = 47,        // 椭圆机          4 MET/70Kg/60分钟/280千卡
    BLE_ACTIVITY_ZUMBA = 48,             // 尊巴            7 MET/70Kg/60分钟/514千卡 舞蹈的一种
    BLE_ACTIVITY_CRICKET = 49,           // 板球            5 MET/70Kg/60分钟/368千卡
    BLE_ACTIVITY_TREKKING = 50,          // 徒步旅行        6 MET/70Kg/60分钟/441千卡
    BLE_ACTIVITY_AEROBICS = 51,          // 有氧运动        5.8 MET/70Kg/60分钟/408千卡
    BLE_ACTIVITY_ROWING_MACHINE = 52,    // 划船机          12 MET/70Kg/60分钟/840千卡
    BLE_ACTIVITY_RUGBY = 53,             // 橄榄球          8 MET/70Kg/60分钟/560千卡
    BLE_ACTIVITY_SIT_UP = 54,            // 仰卧起坐        8 MET/70KG/60分钟/560千卡
    BLE_ACTIVITY_DUM_BLE = 55,           // 哑铃            3 MET/70KG/60分钟/210千卡
    BLE_ACTIVITY_BODY_EXERCISE = 56,     // 健身操          4.7 MET/70KG/60分钟/327千卡
    BLE_ACTIVITY_KARATE = 57,            // 空手道          10 MET/70KG/60分钟/700千卡
    BLE_ACTIVITY_FENCING = 58,           // 击剑            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_MARTIAL_ARTS = 59,      // 武术            13.2 MET/70KG/60分钟/922千卡
    BLE_ACTIVITY_TAI_CHI = 60,           // 太极拳          4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_FRISBEE = 61,           // 飞盘            3 MET/70KG/60分钟/220千卡
    BLE_ACTIVITY_ARCHERY = 62,           // 射箭            4 MET/70KG/60分钟/294千卡
    BLE_ACTIVITY_HORSE_RIDING = 63,      // 骑马            4 MET/70KG/60分钟/294千卡
    BLE_ACTIVITY_BOWLING = 64,           // 保龄球          4 MET/70KG/60分钟/294千卡
    BLE_ACTIVITY_SURF = 65,              // 冲浪            3 MET/70KG/60分钟/220千卡
    BLE_ACTIVITY_SOFTBALL = 66,          // 垒球            5 MET/70KG/60分钟/368千卡
    BLE_ACTIVITY_SQUASH = 67,            // 壁球            8 MET/70KG/60分钟/588千卡
    BLE_ACTIVITY_SAILBOAT = 68,          // 帆船            3 MET/70KG/60分钟/220千卡
    BLE_ACTIVITY_PULL_UP = 69,           // 引体向上        8 MET/70KG/60分钟/560千卡
    BLE_ACTIVITY_SKATEBOARD = 70,        // 滑板            5 MET/70KG/60分钟/350千卡
    BLE_ACTIVITY_TRAMPOLINE = 71,        // 蹦床            6 MET/70KG/60分钟/441千卡
    BLE_ACTIVITY_FISHING = 72,           // 钓鱼            3 MET/70KG/60分钟/220千卡
    BLE_ACTIVITY_POLE_DANCING = 73,      // 钢管舞          6 MET/70KG/60分钟/441千卡
    BLE_ACTIVITY_SQUARE_DANCE = 74,      // 广场舞          3 MET/70KG/60分钟/210千卡
    BLE_ACTIVITY_JAZZ_DANCE = 75,        // 爵士舞          4.8 MET/70KG/60分钟/336千卡
    BLE_ACTIVITY_BALLET = 76,            // 芭蕾舞          4.8 MET/70KG/60分钟/336千卡
    BLE_ACTIVITY_DISCO = 77,             // 迪斯科          4.5 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_TAP_DANCE = 78,         // 踢踏舞          4.8 MET/70KG/60分钟/336千卡
    BLE_ACTIVITY_MODERN_DANCE = 79,      // 现代舞          4.8 MET/70KG/60分钟/336千卡
    BLE_ACTIVITY_PUSH_UPS = 80,          // 俯卧撑          8 MET/70KG/60分钟/560千卡
    BLE_ACTIVITY_SCOOTER = 81,           // 滑板车          7 MET/70KG/60分钟/490千卡
    BLE_ACTIVITY_PLANK = 82,              // 平板支撑        3.3 MET/70KG/60分钟/228千卡
    BLE_ACTIVITY_BILLIARDS = 83,          // 桌球            2.5 MET/70KG/60分钟/175千卡
    BLE_ACTIVITY_ROCK_CLIMBING = 84,      // 攀岩            11 MET/70KG/60分钟/770千卡
    BLE_ACTIVITY_DISCUS = 85,             // 铁饼            4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_RACE_RIDING = 86,        // 赛马            10 MET/70KG/60分钟/700千卡
    BLE_ACTIVITY_WRESTLING = 87,          // 摔跤            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_HIGH_JUMP = 88,          // 跳高            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_PARACHUTE = 89,          // 跳伞            3.5 MET/70KG/60分钟/245千卡
    BLE_ACTIVITY_SHOT_PUT = 90,           // 铅球            4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_LONG_JUMP = 91,          // 跳远            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_JAVELIN = 92,            // 标枪            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_HAMMER = 93,             // 链球            4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_SQUAT = 94,              // 深蹲            4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_LEG_PRESS = 95,          // 压腿            2.5 MET/70KG/60分钟/175千卡
    BLE_ACTIVITY_OFF_ROAD_BIKE = 96,      // 越野自行车      8.3 MET/70KG/60分钟/581千卡
    BLE_ACTIVITY_MOTOCROSS = 97,          // 越野摩托车      4 MET/70KG/60分钟/280千卡
    BLE_ACTIVITY_ROWING = 98,             // 赛艇            8 MET/70KG/60分钟/588千卡
    BLE_ACTIVITY_CROSSFIT = 99,           // CROSSFIT        7 MET/70KG/60分钟/514千卡 通过多种以自身重量、负重 为主的高次数、快速、爆发力的动作增强自己的体能和运动能力
    BLE_ACTIVITY_WATER_BIKE = 100,        // 水上自行车      4 MET/70KG/60分钟/294千卡
    BLE_ACTIVITY_KAYAK = 101,             // 皮划艇          5 MET/70KG/60分钟/368千卡
    BLE_ACTIVITY_CROQUET = 102,           // 槌球            2.5 MET/70KG/60分钟/175千卡
    BLE_ACTIVITY_FLOOR_BALL = 103,        // 地板球          6 MET/70KG/60分钟/441千卡 （福乐球 FLOORBALL） 软式曲棍球
    BLE_ACTIVITY_THAI = 104,              // 泰拳            7 MET/70KG/514 280千卡
    BLE_ACTIVITY_JAI_BALL = 105,          // 回力球          12 MET/70KG/60分钟/840千卡
    BLE_ACTIVITY_TENNIS_DOUBLES = 106,    // 网球(双打)      6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_BACK_TRAINING = 107,     // 背部训练        3.5 MET/70KG/60分钟/245千卡
    BLE_ACTIVITY_WATER_VOLLEYBALL = 108,  // 水上排球        3 MET/70KG/60分钟/210千卡
    BLE_ACTIVITY_WATER_SKIING = 109,      // 滑水            6 MET/70KG/60分钟/420千卡
    BLE_ACTIVITY_MOUNTAIN_CLIMBER = 110,  // 登山机          8 MET/70KG/60分钟/588千卡
    BLE_ACTIVITY_HIIT = 111,              // HIIT            7 MET/70KG/60分钟/514千卡  高强度间歇性训练
    BLE_ACTIVITY_BODY_COMBAT = 112,       // BODY COMBAT     7 MET/70KG/60分钟/514千卡  搏击（拳击）的一种
    BLE_ACTIVITY_BODY_BALANCE = 113,      // BODY BALANCE    7 MET/70KG/60分钟/514千卡  瑜伽、太极和普拉提融合在一起的身心训练项目
    BLE_ACTIVITY_TRX = 114,               // TRX             7 MET/70KG/60分钟/514千卡 全身抗阻力锻炼 全身抗阻力锻炼
    BLE_ACTIVITY_TAE_BO = 115,            // 跆搏（TAE BO）   7 MET/70KG/60分钟/514千卡 集跆拳道、空手道、拳击、自由搏击、舞蹈韵律操为一体
    
    
    BLE_ACTIVITY_BMX = 116,              // 小轮车         //竞赛
    BLE_ACTIVITY_STRETCHING = 117,       // 拉伸           //训练
    BLE_ACTIVITY_INDOOR_FINESS = 118,     // 室内健身       //训练
    BLE_ACTIVITY_FLEXIBILITY = 119, // 柔韧训练        未查到 //训练
    BLE_ACTIVITY_UPPER_LIMB_TRAIN = 120,// 上肢训练      //训练
    BLE_ACTIVITY_LOWER_LIMB_TRAIN = 121,// 下肢训练        //训练
    BLE_ACTIVITY_FREE_EXERCISE = 122,//自由体操        //训练
    BLE_ACTIVITY_BARBELL_TRAINING = 123,// 杠铃             3 MET/70KG/60分钟/210千卡 //训练
    BLE_ACTIVITY_PHYSICAL_TRAINING = 124,// 体能训练         //训练
    BLE_ACTIVITY_DEADLIFT = 125,// 硬拉             //训练
    BLE_ACTIVITY_BOBBY_JUMP = 126,// 波比跳              //训练
    BLE_ACTIVITY_FUNCTION_TRAIN = 127,// 功能性测试       //训练
    BLE_ACTIVITY_WAIST_ABDOMEN_TRAIN = 128,// 腰腹训练         //训练
    BLE_ACTIVITY_TABLE_FOOTBALL = 129,// 桌式足球         //球
    BLE_ACTIVITY_HUNTING = 130,// 打猎             //竞赛
    BLE_ACTIVITY_PADDLEBOARD_SURFING = 131,// 立桨冲浪//竞赛
    BLE_ACTIVITY_KAYAKING_RAFTING = 132,// 皮艇漂流//竞赛
    BLE_ACTIVITY_MOTORBOAT = 133,//摩托艇//竞赛
    BLE_ACTIVITY_PARKOUR = 134,//跑酷//竞赛
    BLE_ACTIVITY_ATV = 135,// 沙滩车//竞赛
    BLE_ACTIVITY_PARAGLIDER = 136,// 滑翔伞//竞赛
    BLE_ACTIVITY_CURLING = 137,// 冰壶//竞赛
    BLE_ACTIVITY_SNOWBOARDING = 138,// 滑雪板//竞赛
    BLE_ACTIVITY_DOUBLE_BOARD = 139,// 滑雪双板//竞赛
    BLE_ACTIVITY_ALPINE_SKIING = 140,// 高山滑雪//竞赛
    BLE_ACTIVITY_CROSS_COUNT = 141,// 越野滑雪//竞赛
    BLE_ACTIVITY_SNOW_MOBILE = 142,//雪地摩托//竞赛
    BLE_ACTIVITY_SNOW_CAR = 143,// 雪车//竞赛
    BLE_ACTIVITY_SLED = 144,// 雪橇//竞赛
    BLE_ACTIVITY_WALLBALL = 145,// 墙球//球
    BLE_ACTIVITY_PUCK = 146,// 冰球//球
    BLE_ACTIVITY_SEPAK_TAKRAW = 147,// 藤球//球
    BLE_ACTIVITY_WATER_POLO = 148,//水球//球
    BLE_ACTIVITY_BELLY = 149,// 肚皮舞//舞
    BLE_ACTIVITY_BALLROOM_DANCE = 150,// 交际舞//舞
    BLE_ACTIVITY_NATIONAL_DANCE = 151,// 民族舞//舞
    BLE_ACTIVITY_LATIN = 152,// 拉丁舞//舞
    BLE_ACTIVITY_JODO = 153, // 柔道//竞赛
    BLE_ACTIVITY_KICKBOXING = 154,//踢拳//竞赛
    BLE_ACTIVITY_FLY_A_KITE = 155,// 放风筝//竞赛
    BLE_ACTIVITY_TUGOFWAR = 156,// 拔河//竞赛
    BLE_ACTIVITY_SHUTTLE = 157,// 毽球//球
    BLE_ACTIVITY_KABADDI = 158,// 卡巴迪//竞赛
    BLE_ACTIVITY_RACING_CAR = 159,// 赛车//竞赛
    BLE_ACTIVITY_SEVEN_STONES = 160,//石子游戏//竞赛
    BLE_ACTIVITY_KHO_KHO = 161,//捉人游戏//竞赛
    // 增加类型时需同步修改cd_workout.c中的 midWorkoutPrepare(), endByStep(), getSportMet(), WORKOUT_TYPE_相关数组
} BleActivityMode;





#endif /* DHBleCommandEnums_h */
