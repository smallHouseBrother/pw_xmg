//
//  XGBaseViewController.m
//  XMG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "XGBaseViewController.h"
#import <UMMobClick/MobClick.h>

@interface XGBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation XGBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_HEX(@"#f0eef4");
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)setBackItem
{
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:0 target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
