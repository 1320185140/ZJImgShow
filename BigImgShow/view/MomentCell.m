//
//  MomentCell.m
//  MomentKit
//
//  Created by ZJ on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUpUI
{
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    _headImageView.clipsToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImageView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [_headImageView addGestureRecognizer:tapGesture];
    // 名字视图
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.top, kTextWidth, 20)];
    _nameLab.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLab.textColor = kHLTextColor;
    _nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLab];
    // 正文视图
    // 行间距
    NSMutableParagraphStyle * stype = [[NSMutableParagraphStyle alloc] init];
    stype.lineSpacing = 4;
    // attributes
    NSMutableDictionary * linkTextAttributes = [NSMutableDictionary dictionary];
    [linkTextAttributes setObject:kLinkTextColor forKey:NSForegroundColorAttributeName]; // 前景色
    [linkTextAttributes setObject:stype forKey:NSParagraphStyleAttributeName]; // 行距
    
    NSMutableDictionary * activeLinkTextAttributes = [NSMutableDictionary dictionary];
    [activeLinkTextAttributes setObject:kLinkTextColor forKey:NSForegroundColorAttributeName]; // 前景色
    [activeLinkTextAttributes setObject:kHLBgColor forKey:NSBackgroundColorAttributeName]; // 背景色
    [activeLinkTextAttributes setObject:stype forKey:NSParagraphStyleAttributeName]; // 行距
    
    _linkLabel = kMLLinkLabel();
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    _linkLabel.linkTextAttributes = linkTextAttributes;
    _linkLabel.activeLinkTextAttributes = activeLinkTextAttributes;
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc]init];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageListView];
    
    
    // 位置视图
    _locationLab = [[UILabel alloc] init];
    _locationLab.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _locationLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_locationLab];
    // 时间视图
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLab];
    // 删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _deleteBtn.backgroundColor = [UIColor clearColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    [self.contentView addSubview:_commentView];
    // 操作视图
    _menuView = [[MMOperateMenuView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [_menuView setOperateMenu:^(MMOperateType operateType) { // 评论|赞
        if ([weakSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [weakSelf.delegate didOperateMoment:weakSelf operateType:operateType];
        }
    }];
    [self.contentView addSubview:_menuView];
    // 最大高度限制
    maxLimitHeight = _linkLabel.font.lineHeight * 6;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    WEAKSELF
    _moment = moment;
    // 头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:moment.userPortrait] placeholderImage:nil];
    // 昵称
    _nameLab.text = moment.userId;
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _nameLab.bottom + kPaddingValue;
    CGFloat rowHeight = 0;
    if ([moment.content length]) {
        _linkLabel.hidden = NO;
        _linkLabel.text = moment.content;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labH = attrStrSize.height;
        if (labH > maxLimitHeight) {
            if (!_moment.isFullText) {
                labH = maxLimitHeight;
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
            } else {
                [self.showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
            _showAllBtn.hidden = NO;
        }
        _linkLabel.frame = CGRectMake(_nameLab.left, bottom, attrStrSize.width, labH);
        _showAllBtn.frame = CGRectMake(_nameLab.left, _linkLabel.bottom + kArrowHeight, kMoreLabWidth, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
    }
        
        // 图片
        _imageListView.moment = moment;
        _imageListView.longPress = ^(MMScrollView *scrollerView) {
            if (self->_longPress) {
                self.longPress(scrollerView);
            }
        };
        _imageListView.videoClick = ^(NSString *url) {
            if (weakSelf.didClickVideo) {
                weakSelf.didClickVideo(url);
            }
        };
        if (moment.imageURLs > 0) {
            _imageListView.origin = CGPointMake(_nameLab.left, bottom);
            bottom = _imageListView.bottom + kPaddingValue;
        }

    // 位置
    _locationLab.frame = CGRectMake(_nameLab.left, bottom, _nameLab.width, kTimeLabelH);
    _timeLab.text = [NSString stringWithFormat:@"%@",[Utility getMomentTime:moment.time]];
    CGFloat textW = [_timeLab.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_timeLab.font} context:nil].size.width;
    if ([moment.location length]) {
        _locationLab.hidden = NO;
        _locationLab.text = moment.location;
        _timeLab.frame = CGRectMake(_nameLab.left, _locationLab.bottom+kPaddingValue, textW, kTimeLabelH);
    } else {
        _locationLab.hidden = YES;
        _timeLab.frame = CGRectMake(_nameLab.left, bottom, textW, kTimeLabelH);
    }
  
        _deleteBtn.hidden = NO;
        _deleteBtn.frame = CGRectMake(_timeLab.right + 25, _timeLab.top, 30, kTimeLabelH);
  
    
    bottom = _timeLab.bottom + kPaddingValue;
    // 操作视图
    _menuView.frame = CGRectMake(SCREEN_WIDTH-kOperateWidth-10, _timeLab.top-(kOperateHeight-kTimeLabelH)/2, kOperateWidth, kOperateHeight);
    _menuView.show = NO;
    _menuView.isLike = moment.isPraise;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = SCREEN_WIDTH-kRightMargin-_nameLab.left;
    if (moment.praiseNameList.length) {
        MLLinkLabel * likeLabel = kMLLinkLabel();
        likeLabel.delegate = self;
        likeLabel.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);
        CGSize attrStrSize = [likeLabel preferredSizeWithMaxWidth:kTextWidth];
        likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        [_commentView addSubview:likeLabel];
        // 分割线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, likeLabel.bottom + 7, width, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_commentView addSubview:line];
        // 更新
        top = attrStrSize.height + 15;
    }
    // 处理评论
    NSInteger count = [moment.review count];
    if (count > 0) {
        for (NSInteger i = 0; i < count; i ++) {
            CommentLabel *label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
            label.userId = moment.userId;
            label.comment = [moment.review objectAtIndex:i];
            [label setDidClickText:^(Comment *comment) {
                if ([self.delegate respondsToSelector:@selector(didSelectComment: WithCell:)]) {
                    [self.delegate didSelectComment:comment WithCell:self];
                }
            }];
            [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
                if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
                    [self.delegate didClickLink:link linkText:linkText];
                }
            }];
            [_commentView addSubview:label];
            // 更新
            top += label.height;
        }
    }
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(_nameLab.left, bottom, width, top + kArrowHeight);
        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        _commentView.frame = CGRectMake(_nameLab.left, bottom + kArrowHeight, width, top);
        rowHeight = _commentView.bottom + kBlank;
    } else {
        rowHeight = _timeLab.bottom + kBlank;
    }
    
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    _moment.rowHeight = rowHeight;
}

#pragma mark - 点击事件

// 查看全文/收起
- (void)fullTextClicked:(UIButton *)sender
{
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        _moment.isFullText = !_moment.isFullText;
        if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [self.delegate didOperateMoment:self operateType:MMOperateTypeFull];
        }
    });
}

// 点击头像
- (void)clickHead:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
        [self.delegate didOperateMoment:self operateType:MMOperateTypeProfile];
    }
}

// 删除动态
- (void)deleteMoment:(UIButton *)sender
{
    _deleteBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _deleteBtn.titleLabel.backgroundColor = [UIColor clearColor];
        if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [self.delegate didOperateMoment:self operateType:MMOperateTypeDelete];
        }
    });
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
        [self.delegate didClickLink:link linkText:linkText];
    }
}
@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel();
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    if ([self.userId isEqualToString:comment.acceptUserId]) {
        comment.isReply = NO;
    }else{
        comment.isReply = YES;
    }
    _linkLabel.attributedText = kMLLinkLabelAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 5;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(link,linkText);
    }
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
        if (self.didClickText) {
            self.didClickText(self->_comment);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}


@end
