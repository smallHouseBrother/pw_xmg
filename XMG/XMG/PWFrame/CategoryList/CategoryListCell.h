//
//  CategoryListCell.h
//  XMG
//
//  Created by jrweid on 2018/6/25.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassWordInfo;

@interface CategoryListCell : UITableViewCell

- (void)reloadCategoryListCellWithInfo:(PassWordInfo *)info;

@end
