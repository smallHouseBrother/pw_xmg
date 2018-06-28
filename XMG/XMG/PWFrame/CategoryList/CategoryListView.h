//
//  CategoryListViewView.h
//  XMG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassWordInfo;

@protocol CategoryListViewDelegate <NSObject>

- (void)checkTheSelectedDetailWithInfo:(PassWordInfo *)info;

- (void)deleteSelectedPassWOrdWithIndex:(NSInteger)index;

@end

@interface CategoryListView : UIView

@property (nonatomic, weak) id <CategoryListViewDelegate> delegate;

- (void)reloadCategoryListTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
