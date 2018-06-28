//
//  RootCell.h
//  XMG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootInfo;

@interface RootCell : UITableViewCell

- (void)reloadRootCellWithInfo:(RootInfo *)info;

@end
