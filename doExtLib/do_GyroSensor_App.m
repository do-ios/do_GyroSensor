//
//  do_GyroSensor_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_GyroSensor_App.h"
static do_GyroSensor_App* instance;
@implementation do_GyroSensor_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_GyroSensor_App alloc]init];
    return instance;
}
@end
