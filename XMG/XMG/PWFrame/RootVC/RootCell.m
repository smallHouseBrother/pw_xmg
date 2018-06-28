//
//  RootCell.m
//  XMG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "RootCell.h"
#import "RootInfo.h"

@interface RootCell ()
{
    UIImageView * _imageView;
    UILabel     * _titleName;
    UILabel     * _accountNum;
}
@end

@implementation RootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 5.f;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout.leftSpaceToView(self.contentView, 15).
    centerYEqualToView(self.contentView).widthIs(40).heightIs(40);
    
    _titleName = [[UILabel alloc] init];
    _titleName.textColor = [UIColor blackColor];
    _titleName.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleName];
    _titleName.sd_layout.leftSpaceToView(_imageView, 15).centerYEqualToView(_imageView).widthIs(100).heightIs(20);
    
    _accountNum = [[UILabel alloc] init];
    _accountNum.textColor = COLOR_HEX(@"EF7700");
    _accountNum.font = [UIFont systemFontOfSize:24];
    _accountNum.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_accountNum];
    _accountNum.sd_layout.rightEqualToView(self.contentView).
    centerYEqualToView(self.contentView).widthIs(100).heightIs(50);
}

- (void)reloadRootCellWithInfo:(RootInfo *)info
{
    _imageView.image = [UIImage imageNamed:info.imageName];
    _titleName.text = info.titleString;
    _accountNum.text = [NSString stringWithFormat:@"%@", @(info.accountNum)];
}

@end
