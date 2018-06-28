//
//  AuthViewController.m
//  XMG
//
//  Created by jrweid on 2018/6/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define Input_Tag 10086

@interface AuthViewController ()
{
    UIView  * _fingerBack;
    UIView  * _pwBack;
    UILabel * _clickFinger;
    UITextField * _backInput;
    BOOL     _isPW;
}
@end

@implementation AuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)addSubViews
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray * iconsName = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [iconsName lastObject]]];
    UIImageView * iconImage = [[UIImageView alloc] initWithImage:image];
    iconImage.layer.cornerRadius = 5.0f;
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:iconImage];
    iconImage.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 100).widthIs(88).heightIs(88);
    
    _fingerBack = [[UIView alloc] init];
    [self.view addSubview:_fingerBack];
    _fingerBack.sd_layout.leftEqualToView(self.view).centerYEqualToView(self.view).widthIs(ScreenWidth).heightIs(66);
    
    UIButton * finger = [[UIButton alloc] init];
    [finger setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    if (iPhoneX) {
        [finger setImage:[UIImage imageNamed:@"faceId"] forState:UIControlStateNormal];
    }
    [finger addTarget:self action:@selector(requestFingerAuth) forControlEvents:UIControlEventTouchUpInside];
    [_fingerBack addSubview:finger];
    finger.sd_layout.centerXEqualToView(_fingerBack).topSpaceToView(_fingerBack, 0).widthIs(66).heightIs(66);
    
    _pwBack = [[UIView alloc] init];
    [self.view addSubview:_pwBack];
    _pwBack.sd_layout.leftSpaceToView(self.view, ScreenWidth).centerYEqualToView(_fingerBack).widthIs(ScreenWidth).heightIs(88);
    
    for (NSInteger i = 0; i < 4; i++) {
        UITextField * input = [[UITextField alloc] init];
        input.textAlignment = NSTextAlignmentCenter;
        input.keyboardType = UIKeyboardTypeNumberPad;
        input.layer.borderColor = COLOR_HEX(@"#72add2").CGColor;
        input.layer.borderWidth = 1.0f;
        input.secureTextEntry = YES;
        input.tag = Input_Tag + i;
        input.enabled = NO;
        [_pwBack addSubview:input];
        input.sd_layout.centerYEqualToView(finger).
        centerXEqualToView(_pwBack).offset(22+44*(i-2)+((2*i+1)-4)*5).widthIs(44).heightIs(44);
    }
    _backInput = [[UITextField alloc] init];
    _backInput.backgroundColor = [UIColor clearColor];
    _backInput.keyboardType = UIKeyboardTypeNumberPad;
    _backInput.textColor = [UIColor clearColor];
    _backInput.tintColor = [UIColor clearColor];
    [_backInput addTarget:self action:@selector(valueDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    [_pwBack addSubview:_backInput];
    _backInput.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _clickFinger = [[UILabel alloc] init];
    _clickFinger.textAlignment = NSTextAlignmentCenter;
    _clickFinger.textColor = COLOR_HEX(@"#72add2");
    _clickFinger.text = @"点击进行指纹解锁";
    if (iPhoneX) {
        _clickFinger.text = @"点击进行面容解锁";
    }
    _clickFinger.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_clickFinger];
    _clickFinger.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).
    topSpaceToView(_fingerBack, 20).heightIs(20);
    
    UIButton * switchBtn = [[UIButton alloc] init];
    [switchBtn setTitle:@"换个方式解锁" forState:UIControlStateNormal];
    [switchBtn setTitleColor:COLOR_HEX(@"#72add2") forState:UIControlStateNormal];
    switchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [switchBtn addTarget:self action:@selector(switchUnLockMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    CGFloat bottom = iPhoneX ? 34 : 0;
    switchBtn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, bottom).widthIs(120).heightIs(40);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestFingerAuth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)valueDidEndEditing:(UITextField *)textField
{
    UITextField * first = [_pwBack viewWithTag:Input_Tag];
    UITextField * second = [_pwBack viewWithTag:Input_Tag+1];
    UITextField * third = [_pwBack viewWithTag:Input_Tag+2];
    UITextField * forth = [_pwBack viewWithTag:Input_Tag+3];
    if (textField.text.length == 0) {
        first.text = @""; second.text = @""; third.text = @""; forth.text = @"";
    } else if (textField.text.length == 1) {
        unichar firstC = [textField.text characterAtIndex:0];
        first.text = [NSString stringWithFormat:@"%c", firstC];
        second.text = @"";  third.text = @"";   forth.text = @"";
    } else if (textField.text.length == 2) {
        unichar secondC = [textField.text characterAtIndex:1];
        second.text = [NSString stringWithFormat:@"%c", secondC];
        third.text = @"";   forth.text = @"";
    } else if (textField.text.length == 3) {
        unichar thirdC = [textField.text characterAtIndex:2];
        third.text = [NSString stringWithFormat:@"%c", thirdC];
        forth.text = @"";
    } else if (textField.text.length == 4) {
        unichar forthC = [textField.text characterAtIndex:3];
        forth.text = [NSString stringWithFormat:@"%c", forthC];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.text.length == 4 && [textField.text isEqualToString:lockPW])
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate returnAuthResult:YES];
            }];
        } else if (textField.text.length == 4) {
            _backInput.text = @"";
            first.text = @""; second.text = @""; third.text = @""; forth.text = @"";
            [UIView animateWithDuration:0.2f animations:^{
                _pwBack.sd_layout.leftSpaceToView(self, -50);
                [_pwBack updateLayout];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                    _pwBack.sd_layout.leftSpaceToView(self, 50);
                    [_pwBack updateLayout];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2f animations:^{
                        _pwBack.sd_layout.leftSpaceToView(self, -50);
                        [_pwBack updateLayout];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2f animations:^{
                            _pwBack.sd_layout.leftSpaceToView(self, 50);
                            [_pwBack updateLayout];
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f animations:^{
                                _pwBack.sd_layout.leftSpaceToView(self, 0);
                                [_pwBack updateLayout];
                            } completion:nil];
                        }];
                    }];
                }];
            }];
        }
    });
}

- (void)switchUnLockMethod
{
    _isPW = !_isPW;
    if (_isPW) {
        _clickFinger.text = @"输入密码进行解锁";
        _fingerBack.sd_layout.leftSpaceToView(self, -ScreenWidth);
        [_fingerBack updateLayout];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:0 animations:^{
            _pwBack.sd_layout.leftSpaceToView(self, 0);
            [_pwBack updateLayout];
        } completion:^(BOOL finished) {
            [_backInput becomeFirstResponder];
            _backInput.text = @"";
        }];
    } else {
        _clickFinger.text = @"点击进行指纹解锁";
        if (iPhoneX) {
            _clickFinger.text = @"点击进行面容解锁";
        }
        _pwBack.sd_layout.leftSpaceToView(self, ScreenWidth);
        [_pwBack updateLayout];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:0 animations:^{
            _fingerBack.sd_layout.leftSpaceToView(self, 0);
            [_fingerBack updateLayout];
        } completion:nil];
    }
}

- (void)requestFingerAuth
{
    LAContext * context = [[LAContext alloc] init];
    [self vertifyWithContext:context withSuccessBlock:^(BOOL isSuccess) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate returnAuthResult:YES];
        }];
    } withAuthFailureBlock:^(NSInteger code) {
        if (code == LAErrorUserFallback)
        {
            XMGLog(@"User tapped Enter Password");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isPW = NO; [self switchUnLockMethod];
            });
        }
        else if (@available(iOS 11.0, *))
        {
            if (code == LAErrorBiometryNotEnrolled)
            {
                if (context.biometryType == LABiometryTypeFaceID) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置面容（Face ID），请在手机“设置＞Face ID与密码”中添加面容或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                } else if (context.biometryType == LABiometryTypeTouchID)   {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        }
        else
        {
            if (code == LAErrorTouchIDNotEnrolled)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - 开始验证按钮点击事件
- (void)vertifyWithContext:(LAContext *)context withSuccessBlock:(void (^)(BOOL isSuccess))successBlock withAuthFailureBlock:(void (^)(NSInteger code))failureBlock
{
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹", nil) reply:^(BOOL success, NSError * _Nullable error)
         {
             if (success)
             {
                 successBlock(YES);
                 return;
             }
             failureBlock(error.code);
         }];
    }
}

@end
