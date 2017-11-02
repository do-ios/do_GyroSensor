//
//  do_GyroSensor_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_GyroSensor_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import <CoreMotion/CoreMotion.h>
#import "doServiceContainer.h"
#import "doILogEngine.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation do_GyroSensor_SM
{
    CMMotionManager *_motionMgr;
    doInvokeResult *invokeResult;
    NSMutableDictionary *node;
}
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
- (void)getGyroData:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    if (_motionMgr.isDeviceMotionAvailable) {
        if (node) {
            [_invokeResult SetResultNode:node];
        }
    }else
        [[doServiceContainer Instance].LogEngine WriteError:nil :@"传感器不可用"];
}
//异步


- (instancetype)init
{
    self = [super init];
    if (self) {
        _motionMgr = [[CMMotionManager alloc] init];
        _motionMgr.deviceMotionUpdateInterval = .1;
        node = [NSMutableDictionary dictionary];
        invokeResult = [[doInvokeResult alloc]init];
    }
    return self;
}

- (void)start:(NSArray *)parms
{
    if (!_motionMgr.isDeviceMotionAvailable) {
        [[doServiceContainer Instance].LogEngine WriteError:nil :@"传感器不可用"];
        return;
    }
    [_motionMgr startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *data, NSError *error) {
        CMAttitude *attitude = _motionMgr.deviceMotion.attitude;
        
        double x = RADIANS_TO_DEGREES(attitude.pitch);
        double y = RADIANS_TO_DEGREES(attitude.roll);
        double z = RADIANS_TO_DEGREES(attitude.yaw);
        
        [node setObject:@(x) forKey:@"x"];
        [node setObject:@(y) forKey:@"y"];
        [node setObject:@(z) forKey:@"z"];
        [invokeResult SetResultNode:node];
        [self.EventCenter FireEvent:@"change" :invokeResult];
        
        NSLog(@"x = %f,y = %f,z = %f",attitude.pitch,attitude.roll,attitude.yaw);
        
        NSLog(@"x1 = %f,y1 = %f,z1 = %f",x,y,z);
    }];
}
- (void)stop:(NSArray *)parms
{
   if (_motionMgr.isDeviceMotionAvailable) {
       [_motionMgr stopDeviceMotionUpdates];
   }
}

@end