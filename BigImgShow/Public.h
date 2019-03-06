//
//  Public.h
//  WechatSociety
//
//  Created by mac on 2/20/19.
//  Copyright © 2019 mac. All rights reserved.
//

#ifndef Public_h
#define Public_h
#import "UIColor+Expanded.h"
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "MomentKit.h"
#import "UUButton.h"
#import "MLLabelUtil.h"
#import "UIView+Geometry.h"
#import <Photos/Photos.h>
#import <ReactiveObjC.h>
#import "Utility.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define Height(h) h

#define Width(w) w
#define GETSIZEMIN(w,h) w>h?h:w
#define DEVICE_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0) ? YES : NO

#define DEVICE_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define Base_Url @"http://192.168.1.129:9501"

// 状态栏高度
#define k_status_height         [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height            self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height            (k_status_height + k_nav_height)
// iPhone X系列
#define k_iphone_x              (SCREEN_HEIGHT >= 812.0f)
// tabbar高度
#define k_bar_height            (k_iphone_x ? 83.0 : 49.0)
// 背景颜色
#define k_background_color      [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0]


#define rgb999999 [UIColor colorWithHexString:@"999999"]

#define rgbf1f1f1 [UIColor colorWithHexString:@"f1f1f1"]

#define rgb666666 [UIColor colorWithHexString:@"666666"]

#define rgb333333 [UIColor colorWithHexString:@"333333"]
#endif /* Public_h */
