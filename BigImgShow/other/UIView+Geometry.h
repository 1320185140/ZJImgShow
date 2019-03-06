//
//  UIView+Geometry.h
//  MomentKit
//
//  Created by ZJ on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Geometry)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;
@property(nonatomic, assign, readonly) CGFloat minX;
@property(nonatomic, assign, readonly) CGFloat minY;
@property(nonatomic, assign, readonly) CGFloat maxX;
@property(nonatomic, assign, readonly) CGFloat maxY;
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;

@property CGPoint origin;
@property CGSize size;

@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;
//获取当前的X
- (CGFloat)current_x;

//获取当前的Y
- (CGFloat)current_y;

//获取当前的H
- (CGFloat)current_h;

//获取当前的W
- (CGFloat)current_w;

//获取当前x位置
- (CGFloat)current_x_w;

//获取当前y位置
- (CGFloat)current_y_h;
@end
