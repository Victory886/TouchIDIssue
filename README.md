TouchIDIssue
============


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
