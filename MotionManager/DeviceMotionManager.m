//
//  DeviceMotionManager.m
//  MotionManager
//
//  Created by ott001 on 2017/12/8.
//  Copyright © 2017年 OTT. All rights reserved.
//

#import "DeviceMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface DeviceMotionManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) DeviceMotionDirection currentDirection;
@property (nonatomic, assign) DeviceMotionDirection targetDirection;
@property (nonatomic, assign) DeviceMotionDirection lastDirection;

@end

@implementation DeviceMotionManager

- (instancetype)init {
    if (self) {
        
        self.currentDirection = DeviceMotionDirectionUp;
        self.lastDirection = DeviceMotionDirectionUp;
    }
    return self;
}

- (void)gyroPull {
    
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    self.motionManager = motionManager;
    
    if ([self.motionManager isGyroAvailable]) {
        
        NSLog(@"-------------- 开启陀螺仪 PULL -------------");
        self.motionManager.gyroUpdateInterval = 0.1;
        [self.motionManager startGyroUpdates];
        
    } else {
        
        NSLog(@"-------------- 陀螺仪不可用 --------------- ");
    }
}

- (void)gyroPush {
    
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    self.motionManager = motionManager;
    
    if ([self.motionManager isGyroAvailable]) {
        
        NSLog(@"-------------- 开启陀螺仪 PUSH ---------- ");
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.motionManager.gyroUpdateInterval = 2;
        [self.motionManager startGyroUpdatesToQueue:queue
                                        withHandler:^(CMGyroData *gyroData, NSError *error)
         {
             NSLog(@"Gyro Rotation x = %.06f", gyroData.rotationRate.x);
             NSLog(@"Gyro Rotation y = %.06f", gyroData.rotationRate.y);
             NSLog(@"Gyro Rotation z = %.06f", gyroData.rotationRate.z);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }];
        
    } else {
        
        NSLog(@"-------------- 陀螺仪不可用 --------------- ");
    }
}

- (void)diviceGyroPush {
    
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    self.motionManager = motionManager;
    
    if ([self.motionManager isDeviceMotionAvailable]) {
        
        self.motionManager.deviceMotionUpdateInterval = 1;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                                            
                                                    [self executeDelegate:motion];
                                                    
                                                }];
        
    }
}

- (void)executeDelegate:(CMDeviceMotion *)motion {
    
    double gravityX = motion.gravity.x;
    double gravityY = motion.gravity.y;
//    double gravityZ = motion.gravity.z;

    if (gravityY < -0.5) {
        self.currentDirection = DeviceMotionDirectionUp;
    }
    if (gravityX < -0.5) {
        self.currentDirection = DeviceMotionDirectionLeft;
    }
    if (gravityY > 0.5) {
        self.currentDirection = DeviceMotionDirectionDown;
    }
    if (gravityX > 0.5) {
        self.currentDirection = DeviceMotionDirectionRight;
    }
    
    if (self.currentDirection == self.lastDirection) {
        
        return;
        
    } else {
        
        NSLog(@"%ld", (long)self.currentDirection);
        
        self.lastDirection = self.currentDirection;
    }
    
}

@end
