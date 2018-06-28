//
//  NSString+Check.h
//  XMG
//
//  Created by 小马哥 on 2017/11/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

+ (BOOL)isPureNumber:(NSString *)string;

+ (BOOL)isPureCharacter:(NSString *)string;

@end
