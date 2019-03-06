//
//  AlertView.h
//  WechatSociety
//
//  Created by mac on 3/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^sureBtnClick)(void);
@interface AlertView : UIView

@property(nonatomic,copy)sureBtnClick sureBtnClick;

-(instancetype)initWithTitle:(NSString *)title Message:(NSString *)message sureButton:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn;
-(void)show;
-(void)disMiss;
@end

NS_ASSUME_NONNULL_END
