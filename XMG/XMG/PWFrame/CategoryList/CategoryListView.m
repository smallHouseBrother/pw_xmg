//
//  CategoryListViewView.m
//  XMG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "CategoryListView.h"
#import "CategoryListCell.h"
#import "PassWordInfo.h"

@interface CategoryListView () <UITableViewDelegate, UITableViewDataSource>
{
    GADBannerView * _bannerView;
    UITableView   * _tableView;
    NSArray       * _dataArray;
    UIImageView   * _imageView;
}
@end

@implementation CategoryListView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = COLOR_HEX(@"#f0eef4");
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    [self addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_tableView registerClass:[CategoryListCell class] forCellReuseIdentifier:@"CategoryListCell"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_Content"]];
    [self addSubview:_imageView = imageView];
    imageView.sd_layout.centerXEqualToView(self).centerYEqualToView(self);
}

- (void)reloadCategoryListTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
{
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = rootVC;
    _bannerView.adUnitID = textId;
    [self addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    _bannerView.sd_layout.leftEqualToView(self).bottomSpaceToView(self, bottom).rightEqualToView(self).heightIs(50);

    _imageView.hidden = (dataArray.count != 0);
    
    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryListCell"];
    PassWordInfo * info = _dataArray[indexPath.row];
    [cell reloadCategoryListCellWithInfo:info];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate deleteSelectedPassWOrdWithIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PassWordInfo * info = _dataArray[indexPath.row];
    
    [self.delegate checkTheSelectedDetailWithInfo:info];
}

@end
