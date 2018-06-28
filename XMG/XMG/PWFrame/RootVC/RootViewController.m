//
//  RootViewController.m
//  XMG
//
//  Created by Zhao Chen on 2018/1/26.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "UIViewController+CWLateralSlide.h"
#import "SearchResultViewController.h"
#import "CategoryListViewController.h"
#import "MoreViewController.h"
#import "RootViewController.h"
#import "SearchBackView.h"
#import "RootView.h"
#import "RootCell.h"
#import "RootInfo.h"

@interface RootViewController () <RootViewDelegate, GADInterstitialDelegate, CategoryListViewControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) SearchResultViewController * searchResult;

@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) GADInterstitial * interstitial;

@property (nonatomic, strong) SearchBackView * backView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) RootView * selfView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
    
    [self requestData];
}

- (void)setNavigation
{
    self.title = @"密码管理";
    
    UIBarButtonItem * more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:0 target:self action:@selector(showMoreBarButtonItem)];
    self.navigationItem.leftBarButtonItem = more;
    
    __weak typeof(self)weakSelf = self;
    //第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf showMoreBarButtonItem];
        }
    }];
}

- (void)addSubViews
{
    self.interstitial = [self createAndLoadInterstitial];
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.selfView = [[RootView alloc] init];
    self.selfView.delegate = self;
    [self.view addSubview:self.selfView];
    self.selfView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    if (@available(iOS 11.0, *)) {
    } else {
        self.selfView.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }

    CGFloat top = 64;   if (iPhoneX)    top = 88 + 10;
    self.backView = [[SearchBackView alloc] init];
    self.backView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    self.backView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(top, 0, 0, 0));
    
    self.searchResult = [[SearchResultViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResult];
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.height = 44;
    self.selfView.tableView.tableHeaderView = self.searchController.searchBar;
    //因为在当前控制器展示结果, 所以不需要这个透明视图
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

- (void)requestData
{
    NSArray * titleArray = @[@"网站", @"邮件", @"游戏", @"社交", @"银行", @"其他"];
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        RootInfo * info = [[RootInfo alloc] init];
        info.titleString = titleArray[i];
        info.typeId = i;
        info.imageName = [NSString stringWithFormat:@"password%@", @(i)];
        info.accountNum = [FMDB_Tool querySingleTypeNumFromDataBaseWithType:i];
        [dataArray addObject:info];
    }
    self.dataArray = [dataArray copy];
    [self.selfView reloadRootTableWithArray:self.dataArray withVC:self];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backView.hidden = NO;
    });
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;
    });
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



#warning here sousuo result

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *inputStr = searchController.searchBar.text ;
    NSLog(@"%@+++++++++++++", inputStr);
    /*if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    for (NSString *str in self.dataArray) {
        
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [self.results addObject:str];
        }
    }
    
    [self.tableView reloadData];*/
}
#pragma mark - RootViewDelegate
- (void)RootViewDidSelectInfo:(RootInfo *)info
{
//    if ([self.interstitial isReady]) {
//        [self.interstitial presentFromRootViewController:self];
//    }
    CategoryListViewController * listVC = [[CategoryListViewController alloc] init];
    listVC.info = info; listVC.delegate = self;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - CategoryListViewControllerDelegate
- (void)returnCurrentTypeWithType:(NSInteger)typeId withNum:(NSInteger)typeNum
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:typeId inSection:0];
    RootCell * cell = [self.selfView.tableView cellForRowAtIndexPath:indexPath];
    RootInfo * info = [self.dataArray objectAtIndex:typeId];
    info.accountNum = typeNum;
    [cell reloadRootCellWithInfo:info];
}

- (GADInterstitial *)createAndLoadInterstitial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:chaPageId];
    [self.interstitial loadRequest:[GADRequest request]];
    self.interstitial.delegate = self;
    return self.interstitial;
}

#pragma mark - GADInterstitialDelegate
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    self.interstitial = [self createAndLoadInterstitial];
}

- (void)showMoreBarButtonItem
{
    MoreViewController * more = [[MoreViewController alloc] init];
    [self cw_showDrawerViewController:more animationType:CWDrawerAnimationTypeDefault configuration:[CWLateralSlideConfiguration defaultConfiguration]];
}

#pragma mark - 自定义处理手势冲突接口
- (BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //如果是自己创建tableview添加在VC的view上 这样写就足够了
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

@end
