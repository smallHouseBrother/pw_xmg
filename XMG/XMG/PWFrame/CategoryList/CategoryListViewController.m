//
//  CategoryListViewController.m
//  XMG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CategoryListView.h"
#import "AddPWViewController.h"
#import "PassWordInfo.h"
#import "RootInfo.h"

@interface CategoryListViewController () <CategoryListViewDelegate, AddPWViewControllerDelegate>
{
    NSArray * _dataArray;
    NSInteger _typeNumber;
}
@end

@implementation CategoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
    
    [self queryData];
}

- (void)setNavigation
{
    [self setBackItem];
    
    self.title = self.info.titleString;
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPassWordRecord)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)addSubViews
{
    CategoryListView * selfView = [[CategoryListView alloc] init];
    selfView.delegate = self;
    self.view = selfView;
}

- (void)queryData
{
    _dataArray = [FMDB_Tool querySingleTypeAllDataFromDataBaseWithType:self.info.typeId];
    _typeNumber = _dataArray.count;
    [(CategoryListView *)self.view reloadCategoryListTableWithArray:_dataArray withVC:self];
}

- (void)addPassWordRecord
{
    AddPWViewController * addPW = [[AddPWViewController alloc] init];
    addPW.typeId = self.info.typeId;
    addPW.delegate = self;
    XGNavigationController * addPwNavi = [[XGNavigationController alloc] initWithRootViewController:addPW];
    [self.navigationController presentViewController:addPwNavi animated:YES completion:nil];
}

#pragma mark - CategoryListViewDelegate
- (void)checkTheSelectedDetailWithInfo:(PassWordInfo *)info
{
    AddPWViewController * addPW = [[AddPWViewController alloc] init];
    addPW.info = info;  addPW.delegate = self;
    [self.navigationController pushViewController:addPW animated:YES];
}

- (void)deleteSelectedPassWOrdWithIndex:(NSInteger)index
{
    NSMutableArray * dataArray = [_dataArray mutableCopy];
    [dataArray removeObjectAtIndex:index];
    _dataArray = [dataArray copy];
    [(CategoryListView *)self.view reloadCategoryListTableWithArray:_dataArray withVC:self];
}

- (void)returnAddedPassWordWithInfo:(PassWordInfo *)info withIsEdit:(BOOL)isEdit
{
    NSMutableArray * dataArray = [_dataArray mutableCopy];
    if (!isEdit)
    {
        [dataArray addObject:info];
        _typeNumber = dataArray.count;
        _dataArray = [dataArray copy];
        [(CategoryListView *)self.view reloadCategoryListTableWithArray:_dataArray withVC:self];
        return;
    }
    
    for (PassWordInfo * pwInfo in _dataArray) {
        if (info.pwId == pwInfo.pwId) {
            NSUInteger index = [_dataArray indexOfObject:pwInfo];
            [dataArray replaceObjectAtIndex:index withObject:info];
            break;
        }
    }
    _dataArray = [dataArray copy];
    [(CategoryListView *)self.view reloadCategoryListTableWithArray:_dataArray withVC:self];
}

- (void)backAction
{
    [self.delegate returnCurrentTypeWithType:self.info.typeId withNum:_typeNumber];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
