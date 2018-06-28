//
//  AddPWView.m
//  XMG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AddPWView.h"
#import "AddPWInfo.h"
#import "AddPWCell.h"
#import <objc/runtime.h>

static char webJumpKey;

@interface AddPWView () <UITableViewDelegate, UITableViewDataSource>
{
    GADBannerView * _bannerView;
    UITableView   * _tableView;
    NSArray       * _dataArray;
}
@end

@implementation AddPWView

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
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = COLOR_HEX(@"#f0eef4");
    _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 88, 0);
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    [self addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_tableView registerClass:[AddPWCell class] forCellReuseIdentifier:@"AddPWCell"];
}

- (void)reloadAddPWCellWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
{
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = rootVC;
    _bannerView.adUnitID = textId;
    [self addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    _bannerView.sd_layout.leftEqualToView(self).bottomSpaceToView(self, bottom).rightEqualToView(self).heightIs(50);
    
    _tableView.tableFooterView = [self getTableFooterWithData:nil];
    
    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (void)checkThisPhoto
{
    [self.delegate AddPWViewSelectPhoto];
}

///网站跳转
- (void)jumpToWebPage:(UIButton *)button
{
    NSString * webString = objc_getAssociatedObject(button, &webJumpKey);
    [self.delegate AddPWViewWebJumpWithWebString:webString];
}

- (UIView *)getTableFooterWithData:(NSData *)imageData
{
    UIView * footer = [[UITableViewCell alloc] init];
    footer.backgroundColor = COLOR_HEX(@"#f0eef4");
    footer.height = 94;
    
    UITableViewCell * photoBack = [[UITableViewCell alloc] init];
    photoBack.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    photoBack.backgroundColor = [UIColor whiteColor];
    photoBack.layer.borderColor = Line_Color.CGColor;
    photoBack.layer.borderWidth = 0.5f;
    [footer addSubview:photoBack];
    photoBack.sd_layout.leftSpaceToView(footer, -0.5).topSpaceToView(footer, 20).rightSpaceToView(footer, -0.5).heightIs(74);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkThisPhoto)];
    [photoBack addGestureRecognizer:tap];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"图片信息";
    [photoBack.contentView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(photoBack.contentView, 15).centerYEqualToView(photoBack.contentView).widthIs(100).heightIs(30);
    
    UIImageView * photo = [[UIImageView alloc] init];
    photo.backgroundColor = [UIColor lightGrayColor];
    photo.layer.cornerRadius = 5.0f;
    photo.layer.masksToBounds = YES;
    [photoBack.contentView addSubview:_photoImg = photo];
    photo.sd_layout.centerYEqualToView(photoBack.contentView).rightEqualToView(photoBack.contentView).widthIs(60).heightIs(60);
    
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * dataArray = _dataArray[section];
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddPWCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddPWCell"];
    AddPWInfo * info = _dataArray[indexPath.section][indexPath.row];
    [cell reloadAddPWCellWithInfo:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat right = 0;
    UITextField * input = [cell.contentView viewWithTag:10000];
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        right += 40;
        if (![cell.contentView viewWithTag:95555]) {
            UIButton * webJump = [[UIButton alloc] init];
            [webJump setImage:[UIImage imageNamed:@"webJump"] forState:UIControlStateNormal];
            webJump.imageEdgeInsets = UIEdgeInsetsMake(10, 8, 10, 8);
            objc_setAssociatedObject(webJump, &webJumpKey, input.text, OBJC_ASSOCIATION_COPY);
            [webJump addTarget:self action:@selector(jumpToWebPage:) forControlEvents:UIControlEventTouchUpInside];
            webJump.tag = 95555;
            [cell.contentView addSubview:webJump];
            webJump.sd_layout.rightEqualToView(cell.contentView).
            centerYEqualToView(cell.contentView).widthIs(40).heightIs(44);
        }
    }
    input.sd_layout.rightSpaceToView(cell.contentView, right);
    [input updateLayout];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        AddPWInfo * info = _dataArray[0][0];
        if (!info.editTime)     return @"密码信息";
        return [NSString stringWithFormat:@"%@时间：%@", info.isEdit ? @"编辑" : @"创建", info.editTime];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)   return nil;
    return @"备注为相关提示信息。";
}

@end
