//
//  CategoryListCell.m
//  XMG
//
//  Created by jrweid on 2018/6/25.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "CategoryListCell.h"
#import "PassWordInfo.h"

@interface CategoryListCell ()
{
    UIImageView * _imageView;
    UILabel     * _titleName;
}
@end

@implementation CategoryListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 5.0f;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout.leftSpaceToView(self.contentView, 15).
    centerYEqualToView(self.contentView).widthIs(40).heightIs(40);
    
    _titleName = [[UILabel alloc] init];
    _titleName.textColor = [UIColor blackColor];
    _titleName.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleName];
    _titleName.sd_layout.leftSpaceToView(_imageView, 15).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).heightIs(44);
}

- (void)reloadCategoryListCellWithInfo:(PassWordInfo *)info
{
    NSString * imageName = [NSString stringWithFormat:@"password%@", @(info.typeId)];
    _imageView.image = [UIImage imageNamed:imageName];
    _titleName.text = info.titleName;
}

@end
