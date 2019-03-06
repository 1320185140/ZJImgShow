//
//  UIColor+Expanded.m
//  Finance
//
//  Created by 尚朋 on 2017/7/19.
//  Copyright © 2017年 尚朋. All rights reserved.
//

#import "UIColor+Expanded.h"

@implementation UIColor (Expanded)

+ (UIColor *)mainColor
{
    return [UIColor colorWithHexString:@"#55ADFF"];
}

+ (UIColor *)mainYellow
{
    return [UIColor colorWithHexString:@"#FFC336"];
}

+ (UIColor *)mainBlack
{
    return [UIColor colorWithHexString:@"#222222"];
}

+ (UIColor *)mainBackColor
{
    return [UIColor colorWithHexString:@"#F5F5F5"];
}

+ (UIColor *)mainSegmentColor
{
    return [UIColor colorWithHexString:@"#DDDDDD"];
}

/**
 训练的种类
 
 - LMDiscoverTrainTypeTheory: 理论，红色 1
 - LMDiscoverTrainTypeTechnological: 紫色 2
 - LMDiscoverTrainTypeBase: 基本，黄色 3
 - LMDiscoverTrainTypeComprehensive: 综合，蓝色 4
 - LMDiscoverTrainTypeOther: 其他，蓝色 5
 */
+ (UIColor *)colorWithType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [self colorWithHexString:@"#EF5053"];
            break;
        case 2:
            return [self colorWithHexString:@"#8268E4"];
            break;
        case 3:
            return [self colorWithHexString:@"#FFB51F"];
            break;
        case 4:
            return [self colorWithHexString:@"#53A5F2"];
            break;
        default:
            return [self colorWithHexString:@"#53A5F2"];
            break;
    }
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color
                          alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
    
}

+ (NSString *)hexFromUIColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end
