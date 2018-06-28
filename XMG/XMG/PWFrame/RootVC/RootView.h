//
//  RootView.h
//  XMG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootInfo;

@protocol RootViewDelegate <NSObject>

- (void)RootViewDidSelectInfo:(RootInfo *)info;

@end

@interface RootView : UIView

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) id <RootViewDelegate> delegate;

- (void)reloadRootTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
