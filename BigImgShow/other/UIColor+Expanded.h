//
//  UIColor+Expanded.h
//  Finance
//
//  Created by 尚朋 on 2017/7/19.
//  Copyright © 2017年 尚朋. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HKAlphaColor(color,a) [UIColor colorWithHexString:color alpha:a]
#define HKColor(color)  HKAlphaColor(color,1)

@interface UIColor (Expanded)

+ (UIColor *)mainColor;

+ (UIColor *)mainYellow;

+ (UIColor *)mainBlack;

+ (UIColor *)mainBackColor;

+ (UIColor *)mainSegmentColor;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color
                          alpha:(CGFloat)alpha;

+ (NSString *)hexFromUIColor:(UIColor *)color;

/**
 训练的种类
 
 - LMDiscoverTrainTypeTheory: 理论，红色 1
 - LMDiscoverTrainTypeTechnological: 紫色 2
 - LMDiscoverTrainTypeBase: 基本，黄色 3
 - LMDiscoverTrainTypeComprehensive: 综合，蓝色 4
 - LMDiscoverTrainTypeOther: 其他，蓝色 5
 */
+ (UIColor *)colorWithType:(NSInteger)type;

@end
