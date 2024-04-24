//
//  DHDailySportModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHDailySportModel.h"

@implementation DHDailySportModel

#define SportTypeTmp 0

- (NSInteger)typeJL2RK:(NSInteger)jlType
{
    int tRKType[60] = {SportTypeWalk, SportTypeWalk, SportTypeWalk, SportTypeWalk, SportTypeWalk, SportTypeWalk, SportTypeWalk,
        SportTypeRunIndoor, SportTypeRunIndoor, SportTypeRunOutdoor, SportTypeRide,SportTypeTmp,SportTypeWalk,
        SportTypeClimb, SportTypeYoga, SportTypeSpinning, SportTypeBasketball, SportTypeFootball, SportTypeBadminton,
        SportTypeTmp, SportTypeWalk, SportTypeFreeExercise, SportTypeTmp, SportTypeTmp, SportTypeWeightLifting,
        SportTypeTmp, SportTypeJumpingRope, SportTypeTmp, SportTypeSkiing, SportTypeSkiing, SportTypeRollerSkating,
        SportTypeTmp, SportTypeTmp, SportTypeGolf, SportTypeBaseball, SportTypeBallet, SportTypeTableTennis,
        SportTypeFootball2, SportTypePilates, SportTypeTmp, SportTypeTmp, SportTypeTmp, SportTypeTmp,
        SportTypeTennis, SportTypeTmp, SportTypeTmp, SportTypeTmp, SportTypeEllipticalMachine};
    
    return tRKType[jlType];
}

@end
