//
//  ViewController.m
//  MotionManager
//
//  Created by ott001 on 2017/11/30.
//  Copyright © 2017年 OTT. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "DeviceMotionManager.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) UILabel *gravityX;
@property (nonatomic, strong) UILabel *gravityY;
@property (nonatomic, strong) UILabel *gravityZ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UILabel *gravityX = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 20)];
    gravityX.textColor = [UIColor blackColor];
    gravityX.text = @"0";
    [self.view addSubview:gravityX];
    self.gravityX = gravityX;
    
    UILabel *gravityY = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 20)];
    gravityY.textColor = [UIColor blackColor];
    gravityY.text = @"0";
    [self.view addSubview:gravityY];
    self.gravityY = gravityY;
    
    UILabel *gravityZ = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 200, 20)];
    gravityZ.textColor = [UIColor blackColor];
    gravityZ.text = @"0";
    [self.view addSubview:gravityZ];
    self.gravityZ = gravityZ;

    DeviceMotionManager *manager = [[DeviceMotionManager alloc] init];
    [manager diviceGyroPush];
}

- (void)gyroPull {
    
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    self.motionManager = motionManager;
    
    if ([self.motionManager isGyroAvailable]) {
        
        NSLog(@"-------------- 开启陀螺仪 PULL -------------");
        
        self.motionManager.gyroUpdateInterval = 0.1;
        [self.motionManager startGyroUpdates];
        
        [self getGyroData];
        
    } else {
        
        NSLog(@"-------------- 陀螺仪不可用 --------------- ");
        
    }
}

//在需要的时候获取值
- (void)getGyroData {
    
    CMRotationRate rotationRate = self.motionManager.gyroData.rotationRate;
    NSLog(@"Gyro Rotation x = %.06f", rotationRate.x);
    NSLog(@"Gyro Rotation y = %.06f", rotationRate.y);
    NSLog(@"Gyro Rotation z = %.06f", rotationRate.z);
    
    self.gravityX.text = [NSString stringWithFormat:@"%f", rotationRate.x];
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
                
                 self.gravityX.text = [NSString stringWithFormat:@"X = %f", gyroData.rotationRate.x];
                 self.gravityY.text = [NSString stringWithFormat:@"Y = %f", gyroData.rotationRate.y];
                 self.gravityZ.text = [NSString stringWithFormat:@"Z = %f", gyroData.rotationRate.z];
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
                                                    double gravityX = motion.gravity.x;
                                                    double gravityY = motion.gravity.y;
                                                    double gravityZ = motion.gravity.z;
                                                    
                                                    // 获取手机的倾斜角度(z是手机与水平面的夹角， xy是手机绕自身旋转的角度)：
                                                    double z = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY))  ;
                                                    
                                                    double xy = atan2(gravityX, gravityY);
                                                    
//                                                    NSLog(@"%f",z);
//                                                    NSLog(@"%f",xy);

                                                    self.gravityX.text = [NSString stringWithFormat:@"X = %f", gravityX];
                                                    self.gravityY.text = [NSString stringWithFormat:@"Y = %f", gravityY];
                                                    self.gravityZ.text = [NSString stringWithFormat:@"Z = %f", gravityZ];

                                                }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
