//
//  ViewController.m
//  TouchIDIssue
//
//  Created by liuge on 11/23/14.
//  Copyright (c) 2014 iLegendSoft. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        self.navigationItem.title = @"点击调用指纹识别";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touch];
}

- (void)touch {
    
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        self.navigationItem.title = @"指纹验证";
        
        LAContext *context = [LAContext new]; //这个属性是设置指纹输入失败之后的弹出框的选项
        context.localizedFallbackTitle = @"输入密码";
        NSError *error = nil;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                 error:&error]) {
            
            NSLog(@"支持指纹识别");
            
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"指纹登录"
                              reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    
                    NSLog(@"验证成功 刷新主界面");
                } else {
                    
                    NSLog(@"%@",error.localizedDescription);
                    switch (error.code) {
                        case LAErrorSystemCancel: {
                            
                            NSLog(@"系统取消授权，如其他APP切入");
                            break;
                        }
                        case LAErrorUserCancel: {
                            
                            NSLog(@"用户取消验证Touch ID");
                            break;
                        }
                        case LAErrorAuthenticationFailed: {
                            
                            NSLog(@"授权失败");
                            break;
                        }
                        case LAErrorPasscodeNotSet: {
                            
                            NSLog(@"系统未设置密码");
                            break;
                        }
                        case LAErrorTouchIDNotAvailable: {
                            
                            NSLog(@"设备Touch ID不可用，例如未打开");
                            break;
                        }
                        case LAErrorTouchIDNotEnrolled: {
                            
                            NSLog(@"设备Touch ID不可用，用户未录入");
                            break;
                        }
                        case LAErrorUserFallback: {
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                
                                NSLog(@"用户选择输入密码，切换主线程处理");
                            }];
                            break;
                        }
                        default: {
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSLog(@"其他情况，切换主线程处理");
                            }];
                            break;
                        }
                    }
                }
            }];
        } else {
            
            NSLog(@"不支持指纹识别");
            
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled: {
                    
                    NSLog(@"TouchID is not enrolled");
                    break;
                }
                case LAErrorPasscodeNotSet: {
                    
                    NSLog(@"A passcode has not been set");
                    break;
                }
                default: {
                    
                    NSLog(@"TouchID not available");
                    break;
                }
            }
            
            NSLog(@"%@",error.localizedDescription);
        }
    }

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
