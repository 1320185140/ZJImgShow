//
//  MomentViewController.m
//  MomentKit
//
//  Created by ZJ on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentViewController.h"
#import "MomentCell.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AlertView.h"
@interface MomentViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate,UITextFieldDelegate,AVPlayerViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UITextField * tf;
@property (nonatomic, strong) UIView * modeView;
@property (nonatomic, strong) Moment * moment;//点击评论的momnet
@property (nonatomic, strong) Comment * coment;//点击评论的comment
@property (nonatomic, assign)BOOL isReplay;//是否点击的回复
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)CGFloat cellOrignY;
@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;

@end

@implementation MomentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友动态";
    self.cellHeight = 0;
    self.cellOrignY = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * array =@[@{@"content":@"",
                         @"createTime":@"2019-03-05 16:01:47",
                         @"fileType":@"0",
                         @"hight":@"461",
                         @"id":@"25246803607822336",
                         @"imageURLs":@[@"http://192.168.1.129/group1/M00/00/09/wKgBgVx-LOqAccKpAAQIsgwqNy8063.png",
                                    @"http://192.168.1.129/group1/M00/00/09/wKgBgVx4qXeAftI5AASJHt-wiiE142.png",
                                    @"http://192.168.1.129/group1/M00/00/09/wKgBgVx4qXeAPT_NAAOZskgOhHY163.png",
                                    @"http://192.168.1.129/group1/M00/00/09/wKgBgVx4qXeAWD9sAAQCkIi7tz0284.png",
                                        ],
                         @"review":@[],
                         @"userId":@"123456",
                         @"weight":@"1200"},
                       @{@"content":@"",
                          @"createTime":@"2019-03-05 16:01:47",
                          @"fileType":@"0",
                          @"hight":@"461",
                          @"id":@"25246803607822336",
                          @"imageURLs":@[@"http://192.168.1.129/group1/M00/00/09/wKgBgVx-LOqAccKpAAQIsgwqNy8063.png"
                                        ],
                          @"review":@[],
                          @"userId":@"123456",
                          @"weight":@"1200"},
                       @{@"content":@"",
                           @"createTime":@"2019-03-05 16:01:47",
                           @"fileType":@"0",
                           @"hight":@"461",
                           @"id":@"25246803607822336",
                           @"imageURLs":@[@"http://192.168.1.129/group1/M00/00/09/wKgBgVx4qXeAftI5AASJHt-wiiE142.png"
                                         ],
                           @"review":@[],
                           @"userId":@"123456",
                           @"weight":@"1200"},
                       @{@"content":@"",
                        @"createTime":@"2019-03-05 16:01:47",
                        @"fileType":@"0",
                        @"hight":@"461",
                        @"id":@"25246803607822336",
                        @"imageURLs":@[@"http://192.168.1.129/group1/M00/00/09/wKgBgVx4qXeAftI5AASJHt-wiiE142.png",                                                                       ],
                        @"review":@[],
                        @"userId":@"123456",
                        @"weight":@"1200"}];
    for (NSDictionary * dic in array) {
        Moment * moment = [Moment mj_objectWithKeyValues:dic];
        [self.momentList addObject:moment];
    }
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.view addSubview:self.tf];
    [self.view addSubview:self.modeView];
}



- (void)keyboardChange:(NSNotification *)note{
    
    //拿到键盘弹出的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    //修改底部输入框的约束
//    self.bottomConstrain.constant = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    
    //键盘弹出所需时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //添加输入框弹出和收回动画
    [UIView animateWithDuration:duration animations:^{
        if (frame.origin.y == SCREEN_HEIGHT) {
            self.tf.frame =CGRectMake(0, frame.origin.y, SCREEN_WIDTH, 40);
            self.tf.text = @"";
            self.modeView.hidden = YES;
//            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            [self calculateWithHeight:frame.size.height +40];
            self.modeView.hidden = NO;
            self.tf.frame = CGRectMake(0, frame.origin.y - 40, SCREEN_WIDTH, 40);
            self.modeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - frame.size.height);
        }
        
        //立即刷新进行重新布局
        [self.view layoutIfNeeded];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *  acceptId = self.isReplay?self.coment.commentsUserId:self.moment.userId;
//    NSDictionary * dic = @{@"publishContentId":self.moment.ID,@"commentsContent":self.tf.text,@"commentsUserId":[User shareInstance].userId,@"acceptUserId":acceptId};
//    [MomentNetWork publishRview:dic Success:^(id  _Nonnull responseObject) {
//        NSLog(@"评论成功-----%@",responseObject);
//        [self requestAllMessageWithOneCellReload];
//    } failure:^(id  _Nonnull responseObject) {
//        NSLog(@"评论失败=====%@",responseObject);
//    }];
    [self.tf resignFirstResponder];
    return YES;
}







-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self requestAllMessage];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 测试数据

//-(void)requestAllMessage{
//    NSDictionary * dic = @{@"time":@"0",@"type":@"0"};
//    [MomentNetWork getReleaseContent:dic Success:^(id  _Nonnull responseObject) {
//        NSLog(@"success---%@",responseObject);
//        [self.momentList removeAllObjects];
//        NSArray * array = responseObject[@"data"];
//        for (NSDictionary * dic in array) {
//            Moment * model = [Moment mj_objectWithKeyValues:dic];
//            [self.momentList addObject:model];
//        }
//        [self.tableView reloadData];
//    } failure:^(id  _Nonnull responseObject) {
//        NSLog(@"failure---%@",responseObject);
//    }];
//}
//
//-(void)requestAllMessageWithOneCellReload{
//    NSDictionary * dic = @{@"time":@"0",@"type":@"0"};
//    [MomentNetWork getReleaseContent:dic Success:^(id  _Nonnull responseObject) {
//        NSLog(@"success---%@",responseObject);
//        NSArray * array = responseObject[@"data"];
//        for (NSDictionary * dic in array) {
//            Moment * model = [Moment mj_objectWithKeyValues:dic];
//            if ([self.moment.ID isEqualToString:model.ID]) {
//                self.moment.review = model.review;
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//        });
//
//
//    } failure:^(id  _Nonnull responseObject) {
//        NSLog(@"failure---%@",responseObject);
//    }];
//}

-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    
    return [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]*1000];
    
}
#pragma mark - UI
- (void)setUpUI
{
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [view addSubview:self.coverImageView];
    [view addSubview:self.headImageView];
    self.tableHeaderView = view;
    // 表格
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.view addSubview:self.tableView];
}



#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - MomentCellDelegate
- (void)didOperateMoment:(MomentCell *)cell operateType:(MMOperateType)operateType;
{
    switch (operateType)
    {
        case MMOperateTypeProfile: // 点击用户头像
        {
            NSLog(@"击用户头像");
             break;
        }
        case MMOperateTypeDelete: // 删除
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 取消
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary * dic =@{@"id":cell.moment.ID};
               
              
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case MMOperateTypeLike: // 点赞
        {
           
            [self.tableView reloadData];
            break;
        }
        case MMOperateTypeComment: // 评论
        {
            self.isReplay = NO;
            self.moment = cell.moment;
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            self.indexPath = indexPath;
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
            CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            self.cellHeight = rect.origin.y + CGRectGetMaxY(cell.menuView.frame);
            self.cellOrignY = cell.frame.origin.y - rect.origin.y;
            [self.tf becomeFirstResponder];
            break;
        }
        case MMOperateTypeFull: // 全文/收起
        {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        default:
            break;
    }
}

-(void)calculateWithHeight:(CGFloat)height{
    CGFloat moveHeight =height - (SCREEN_HEIGHT - self.cellHeight);
    NSLog(@"%f------%f",moveHeight,self.cellHeight);
     [self.tableView setContentOffset:CGPointMake(0, moveHeight +self.cellOrignY) animated:YES];
}

// 选择评论
- (void)didSelectComment:(Comment *)comment WithCell:(MomentCell *)cell
{
    self.isReplay = YES;
    self.moment = cell.moment;
    self.coment = comment;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    self.indexPath = indexPath;
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    self.cellHeight = rect.origin.y + CGRectGetMaxY(cell.commentView.frame);
    self.cellOrignY = cell.frame.origin.y - rect.origin.y;
    [self.tf becomeFirstResponder];
    NSLog(@"点击评论");
}

// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText
{
    NSLog(@"点击高亮文字：%@",linkText);
    switch (link.linkType)
    {
        case MLLinkTypeURL: // 链接
        {
           
            break;
        }
        case MLLinkTypePhoneNumber: // 电话
        {
          
            break;
        }
        case MLLinkTypeEmail: // 邮箱
        {
      
            break;
        }
        case MLLinkTypeUserHandle: // @
        {
            break;
        }
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.momentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    Moment * moment = [self.momentList objectAtIndex:indexPath.row];
    static NSString * identifier;
     identifier= @"MomentCell";

    MomentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.didClickVideo = ^(NSString *url) {
       [weakSelf playVideo:url];
    };
    cell.longPress = ^(MMScrollView *scrollView) {
        [weakSelf longPress:scrollView];
    };
    cell.tag = indexPath.row;
    return cell;
}

-(void)longPress:(MMScrollView *)scrollView{
    UIImage * image = scrollView.imageView.image;
    AlertView * alert = [[AlertView alloc]initWithTitle:@"提示" Message:@"是否保存" sureButton:@"确认" cancleBtn:@"取消"];
    alert.sureBtnClick = ^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@--%@",@"保存失败",error);
                } else {
                    NSLog(@"%@",@"保存成功");
                }
            }];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            NSLog(@"success = %d, error = %@", success, error);
            
        }];
    };
    [alert show];
}


-(void)playVideo:(NSString *)outputURL{
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp4"];
    
    NSURL *url = [NSURL URLWithString:outputURL];
    
    AVPlayerViewController *play = [[AVPlayerViewController alloc] init];
    
    play.player = [[AVPlayer alloc] initWithURL:url];
    
    // 是否显示视频播放控制控件默认YES
    play.showsPlaybackControls = YES;
    
    
    // 设置视频播放界面的尺寸播放选项
    // AVLayerVideoGravityResizeAspect   默认 不进行比例缩放 以宽高中长的一边充满为基准
    // AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
    // AVLayerVideoGravityResize     进行缩放充满屏幕
    play.videoGravity = @"AVLayerVideoGravityResizeAspect";
    
    // 获取是否已经准备好开始播放
    //    play.isReadyForDisplay
    
    // 获取视频播放界面的尺寸
    //    play.videoBounds
    
    // 视频播放器的视图 自定义的控件可以添加在其上
    //    play.contentOverlayView
    
    // 画中画代理iOS9后可用
    play.delegate = self;
    
    // 是否支持画中画 默认YES
    play.allowsPictureInPicturePlayback = NO;

    //    [play.player play];
    [self presentViewController:play animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 使用缓存行高，避免计算多次
    Moment * moment = [self.momentList objectAtIndex:indexPath.row];
    return moment.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Moment * moment = [self.momentList objectAtIndex:indexPath.row];
    if (moment.rowHeight) {
        return moment.rowHeight;
    }
    return UITableViewAutomaticDimension;
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath * indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    MomentCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -k_top_height, SCREEN_WIDTH, 270)];
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.image = [UIImage imageNamed:@"moment_cover"];
    }
    return _coverImageView;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, self.coverImageView.bottom-40, 75, 75)];
        _headImageView.backgroundColor = [UIColor lightGrayColor];
        _headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _headImageView.layer.borderWidth = 2;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.image = [UIImage imageNamed:@"moment_head"];
    }
    return _headImageView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

-(NSMutableArray *)momentList{
    if (!_momentList) {
        _momentList = [[NSMutableArray alloc]init];
    }
    return _momentList;
}

-(Comment *)coment{
    if (!_coment) {
        _coment = [[Comment alloc]init];
    }
    return _coment;
}

-(Moment *)moment{
    if (!_moment) {
        _moment = [[Moment alloc]init];
    }
    return _moment;
}

-(UITextField *)tf{
    if (!_tf) {
        _tf = [[UITextField alloc]init];
        _tf.placeholder = @"评论";
        _tf.delegate = self;
        _tf.returnKeyType = UIReturnKeySend;
        _tf.enablesReturnKeyAutomatically = YES;
        _tf.backgroundColor = [UIColor whiteColor];
    }
    return _tf;
}

-(UIView *)modeView{
    if (!_modeView) {
        _modeView = [[UIView alloc]init];
        _modeView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
        [_modeView addGestureRecognizer:tap];
    }
    return _modeView;
}

-(void)tapEvent{
    [self.tf resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tf resignFirstResponder];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
