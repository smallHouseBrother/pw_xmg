//
//  NSString+XMGDynamic.m
//  小马哥
//
//  Created by 小马哥 on 2017/10/20.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "NSString+XMGDynamic.h"

@implementation NSString (XMGDynamic)

+ (NSString *)dynamicGenerate16BitString
{
    char bytes16String[16];
    
    for (NSInteger x = 0; x < 16; bytes16String[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:bytes16String length:16 encoding:NSUTF8StringEncoding];
}

@end
