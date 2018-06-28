//
//  AddPWCell.m
//  XMG
//
//  Created by jrweid on 2018/6/26.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AddPWCell.h"
#import "AddPWInfo.h"

@interface AddPWCell () <UITextFieldDelegate>
{
    UITextField * _textInput;
    UILabel     * _titleLabel;
    AddPWInfo   * _addInfo;
}
@end

@implementation AddPWCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleLabel = titleLabel];
    titleLabel.sd_layout.leftSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(60).heightIs(44);
    
    UITextField * textInput = [[UITextField alloc] init];
    textInput.textColor = [UIColor blackColor];
    textInput.font = [UIFont systemFontOfSize:17];
    textInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    textInput.tag = 10000;
    textInput.delegate = self;
    [self.contentView addSubview:_textInput = textInput];
    textInput.sd_layout.leftSpaceToView(titleLabel, 0).centerYEqualToView(titleLabel).rightSpaceToView(self.contentView, 0).heightIs(44);
}

- (void)reloadAddPWCellWithInfo:(AddPWInfo *)info
{
    _addInfo = info;
    _titleLabel.text = info.leftTitle;
    _textInput.placeholder = info.titlePlace;
    _textInput.text = info.titleInput;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _addInfo.titleInput = textField.text;
}

@end
