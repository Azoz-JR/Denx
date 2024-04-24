//
//  DHBleBaseModel.h
//  DHFoundation
//
//  Created by DHS on 2022/5/30.
//

#import <Foundation/Foundation.h>

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"
#define primaryId   @"pk"

NS_ASSUME_NONNULL_BEGIN

@interface DHBleBaseModel : NSObject

/** 主键 id */
@property (nonatomic, assign) NSInteger pk;

@property (nonatomic,copy,nullable) NSString * macAddr;

@property (nonatomic,copy,nullable) NSString * userId;

/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray *columeNames;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray *columeTypes;

/** 获取该类的所有属性 */
+ (NSDictionary *)getPropertys;

/** 获取所有属性，包括主键 */
+ (NSDictionary *)getAllProperties;

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable;

/** 表中的字段*/
+ (NSArray *)getColumns;

/** 保存或更新
 * 如果不存在主键，保存；有主键，则更新
 */
- (BOOL)saveOrUpdate;

/** 保存或更新
 * 如果根据特定的列数据可以获取记录，则更新，
 * 没有记录，则保存
 */
+ (float)caluteMaxOf:(NSString *)param with:(NSString *)format,...;

+ (float)findLastTargetOfSport:(NSString *)timeStrp;
+ (instancetype)findLastModelOfTarget:(NSString *)timeStep;
+ (NSString *)findfirstDateOfSport:(NSString *)timeStrp;
- (BOOL)saveOrUpdateByColumnName:(NSString*)columnName AndColumnValue:(NSString*)columnValue;

/** 保存单个数据 */
- (BOOL)save;
/** 批量保存数据 */
+ (BOOL)saveObjects:(NSArray *)array;
/** 更新单个数据 */
- (BOOL)update;
/** 批量更新数据*/
+ (BOOL)updateObjects:(NSArray *)array;
/** 删除单个数据 */
- (BOOL)deleteObject;
/** 批量删除数据 */
+ (BOOL)deleteObjects:(NSArray *)array;
/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;
/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...;
/** 清空表 */
+ (BOOL)clearTable;
/** 查询全部数据 */
+ (NSArray *)findAll;

/** 通过主键查询 */
+ (instancetype)findByPK:(int)inPk;

+ (instancetype)findFirstWithFormat:(NSString *)format, ...;

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

+ (NSArray *)findWithFormat:(NSString *)format, ...;

/** 通过条件查找数据
 * 这样可以进行分页查询 @" WHERE pk > 5 limit 10"
 */
+ (NSArray *)findByCriteria:(NSString *)criteria;

/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;

//查询总条数
+ (void)queryCountOfMyTable:(void(^)(int))block and:(NSString *)format, ...;
//查询总条数
+ (NSInteger )queryTotalCountOfMyTableAnd:(NSString *)format, ...;
//求和
+ (float)calucateSumOf:(NSString *)param with:(NSString *)format,...;

#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients;

+ (NSInteger)findCountWithCriteria:(NSString *)criteria;

/**
 不过不确定是否存在自己的表名，重写此方法并返回表名
 
 @return 返回对应表名
 */
+ (NSString *)getTableName;

+ (float)getMaxValueWith:(NSString *)columeName;

@end

NS_ASSUME_NONNULL_END