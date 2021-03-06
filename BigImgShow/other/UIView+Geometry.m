//
//  UIView+Geometry.m
//  MomentKit
//
//  Created by ZJ on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)

- (CGPoint)origin
{
    return self.frame.origin;
}
-(void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x{
    
    return  self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)y{
    
    return  self.frame.origin.y;
}

-(CGFloat)minX{
    
    return self.x;
}

-(CGFloat)maxX{
    
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)minY{
    
    return self.y;
}

-(CGFloat)maxY{
    
    return CGRectGetMaxY(self.frame);
}

- (void)setOrigin:(CGPoint)aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)centetX
{
    return self.center.x;
}

- (void)setCentetX:(CGFloat)centetX
{
    CGPoint center = self.center;
    center.x = centetX;
    self.center = center;
}

- (CGFloat)centetY
{
    return self.center.y;
}

- (void)setCentetY:(CGFloat)centetY
{
    CGPoint center = self.center;
    center.y = centetY;
    self.center = center;
}
- (CGFloat)current_x{
    return self.frame.origin.x;
}



- (CGFloat)current_y{
    return self.frame.origin.y;
}

- (CGFloat)current_h{
    return self.frame.size.height;
}

- (CGFloat)current_w{
    return self.frame.size.width;
}

- (CGFloat)current_x_w{
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)current_y_h{
    return self.frame.origin.y+self.frame.size.height;
}
@end
