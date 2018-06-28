//
//  CategoryListViewController.h
//  XMG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

@class RootInfo;

@protocol CategoryListViewControllerDelegate <NSObject>

- (void)returnCurrentTypeWithType:(NSInteger)typeId withNum:(NSInteger)typeNum;

@end

@interface CategoryListViewController : XGBaseViewController

@property (nonatomic, strong) RootInfo * info;

@property (nonatomic, weak) id <CategoryListViewControllerDelegate> delegate;

@end
