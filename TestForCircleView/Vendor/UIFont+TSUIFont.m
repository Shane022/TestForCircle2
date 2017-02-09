//
//  UIFont+TSUIFont.m
//  UVideo-V5-iPhone
//
//  Created by suma_i_Interactive on 15/4/27.
//  Copyright (c) 2015年 sumavision. All rights reserved.
//

#import "UIFont+TSUIFont.h"

@implementation UIFont (TSUIFont)

+(UIFont *)setSystemFontWithPx:(CGFloat)px
{
    CGFloat pound = (px/96)*72;
    return [UIFont systemFontOfSize:pound];
}

@end

