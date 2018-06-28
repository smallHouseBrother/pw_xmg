//
//  NSString+Check.m
//  XMG
//
//  Created by 小马哥 on 2017/11/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+ (BOOL)isPureNumber:(NSString *)string
{
    NSScanner * scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}

+ (BOOL)isPureCharacter:(NSString *)string
{
    for(NSInteger i = 0; i < string.length; i++)
    {
        unichar charcater = [string characterAtIndex:i];
        if((charcater < 'A' || charcater >'Z') && (charcater < 'a' || charcater > 'z'))
        {
            return NO;
        }
    }
    return YES;
}

@end
