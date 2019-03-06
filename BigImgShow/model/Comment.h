//
//  Comment.h
//  MomentKit
//
//  Created by ZJ on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  评论Model
//
#import <Foundation/Foundation.h>

@interface Comment : NSObject

// 正文
@property (nonatomic, copy) NSString * commentsContent;
//被回复者
@property (nonatomic, copy) NSString * acceptUserId;
//回复者名字
@property (nonatomic, copy) NSString * commentsUserId;
// 发布时间戳
@property (nonatomic, copy) NSString * createTime;
// 关联动态的PK
@property (nonatomic, copy)NSString * ID;
// 回复
@property (nonatomic, assign) BOOL isReply;

@end
