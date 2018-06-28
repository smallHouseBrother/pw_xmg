//
//  AuthViewController.h
//  XMG
//
//  Created by jrweid on 2018/6/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

@protocol AuthViewControllerDelegate <NSObject>

- (void)returnAuthResult:(BOOL)isSuccess;

@end

@interface AuthViewController : XGBaseViewController

@property (nonatomic, weak) id <AuthViewControllerDelegate> delegate;

@end
