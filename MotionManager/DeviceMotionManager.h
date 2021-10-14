//
//  DeviceMotionManager.h
//  MotionManager
//
//  Created by ott001 on 2017/12/8.
//  Copyright © 2017年 OTT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceMotionDirection) {
    DeviceMotionDirectionUp = 0,
    DeviceMotionDirectionDown = 1,
    DeviceMotionDirectionLeft = 2,
    DeviceMotionDirectionRight = 3
};

@class DeviceMotionManagerDelegate;

@interface DeviceMotionManager : NSObject

@property (nonatomic, weak) DeviceMotionManagerDelegate *delegate;

- (void)gyroPull;

- (void)gyroPush;

- (void)diviceGyroPush;

@end

@protocol DeviceMotionManagerDelegate <NSObject>

- (void)deviceMotionDirection:(DeviceMotionDirection)diretion;

@end
