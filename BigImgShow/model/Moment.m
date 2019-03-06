//
//  Moment.m
//  MomentKit
//
//  Created by ZJ on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Moment.h"

@implementation Moment

+ (NSArray *)transients
{
    return [NSArray arrayWithObjects:@"review", nil];
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"review" : [Comment class]};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
