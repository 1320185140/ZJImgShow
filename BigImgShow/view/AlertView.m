//
//  AlertView.m
//  WechatSociety
//
//  Created by mac on 3/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()

@property(nonatomic,copy)UIView * bgView;

@property(nonatomic,copy)UIView * topView;

@property(nonatomic,copy)UILabel * title;

@property(nonatomic,copy)UILabel * message;

@property(nonatomic,copy)UIButton * sureBtn;

@property(nonatomic,copy)UIButton * cancleBtn;

@end

@implementation AlertView

-(instancetype)initWithTitle:(NSString *)title Message:(NSString *)message sureButton:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor clearColor];
        _title.text = title;
        _message.text = message;
        [_sureBtn setTitle:sureBtn forState:UIControlStateNormal];
        [_cancleBtn setTitle:cancleBtn forState:UIControlStateNormal];
        _topView.frame = CGRectMake(0, SCREEN_HEIGHT - 40 - 180, SCREEN_WIDTH, 120);
        _title.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 30);
        _message.frame = CGRectMake(15, 30, SCREEN_WIDTH-30, 40);
        _sureBtn.frame = CGRectMake(15, _message.maxY +1, SCREEN_WIDTH - 30, 50);
        _cancleBtn.frame = CGRectMake(15, SCREEN_HEIGHT - 90, SCREEN_WIDTH - 30, 50);
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return self;
}

-(void)show{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)disMiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

-(void)addUI{
    [self.topView addSubview:self.bgView];
    [self.topView addSubview:self.title];
    [self.topView addSubview:self.message];
    [self.topView addSubview:self.sureBtn];
    [self addSubview:self.topView];
    [self addSubview:self.cancleBtn];
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        _title.layer.masksToBounds = YES;
        _title.font = [UIFont systemFontOfSize:12];
    }
    return _title;
}

-(UILabel *)message{
    if (!_message) {
        _message = [[UILabel alloc]init];
        _message.backgroundColor =  [UIColor colorWithWhite:1 alpha:0.9];;
        _message.textAlignment = NSTextAlignmentCenter;
        _message.textColor = [UIColor colorWithHexString:@"#999999"];
        _message.font = [UIFont systemFontOfSize:12];
    }
    return _message;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        _sureBtn.backgroundColor =  [UIColor colorWithWhite:1 alpha:0.9];
        [[_sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self disMiss];
            if (self->_sureBtnClick) {
                self.sureBtnClick();
            }
        }];
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _sureBtn;
}



-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc]init];
        _cancleBtn.layer.cornerRadius = 10;
        [[_cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self disMiss];
        }];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"#4169E1"] forState:UIControlStateNormal];
        _cancleBtn.backgroundColor =  [UIColor colorWithWhite:1 alpha:0.9];;
    }
    return _cancleBtn;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
            [self disMiss];
        }];
        [_bgView addGestureRecognizer:tapGesture];
        _bgView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    return _bgView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.layer.cornerRadius = 10;
//        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

@end
