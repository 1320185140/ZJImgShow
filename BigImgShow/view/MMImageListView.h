//
//  MMImageListView.h
//  MomentKit
//
//  Created by ZJ on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  朋友圈动态 > 小图区视图
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "MMImagePreviewView.h"


@interface MMImageListView : UIView

// 动态
@property (nonatomic,strong) Moment *moment;

@property (nonatomic, copy) void (^videoClick)(NSString *url);

@property (nonatomic, copy) void (^longPress)(MMScrollView *scrollerView);


@end



//### 单个小图显示视图
@interface MMImageView : UIImageView

// 点击小图
@property (nonatomic, copy) void (^tapSmallView)(MMImageView *imageView);

@end

