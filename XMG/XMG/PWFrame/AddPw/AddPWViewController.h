//
//  AddPWViewController.h
//  XMG
//
//  Created by jrweid on 2018/6/4.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

@class PassWordInfo;

@protocol AddPWViewControllerDelegate <NSObject>

- (void)returnAddedPassWordWithInfo:(PassWordInfo *)info withIsEdit:(BOOL)isEdit;

@end

@interface AddPWViewController : XGBaseViewController

///查看
@property (nonatomic, strong) PassWordInfo * info;

///新增所属类型
@property (nonatomic) NSInteger typeId;


@property (nonatomic, weak) id <AddPWViewControllerDelegate> delegate;

@end
