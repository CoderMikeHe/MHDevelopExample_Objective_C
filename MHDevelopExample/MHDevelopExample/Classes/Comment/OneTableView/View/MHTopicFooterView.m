//
//  MHTopicFooterView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicFooterView.h"

@interface MHTopicFooterView ()
/** 分割线 */
@property (nonatomic , weak) MHDivider *divider;

/** 第几组 */
@property (nonatomic , assign) NSInteger section;

@end


@implementation MHTopicFooterView

+ (instancetype)videoTopicFooterView
{
    return [[self alloc] init];
}

+ (instancetype)footerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TopicFooter";
    MHTopicFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footer == nil) {
        // 缓存池中没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 公共方法
- (void)setSection:(NSInteger)section allSections:(NSInteger)sections
{
    self.section = section;
    
    if (sections == 1) {
        self.divider.hidden = YES;
    } else if (section == 0) { // 首行
        self.divider.hidden = NO;
    } else if (section == sections - 1) { // 末行
        self.divider.hidden = YES;
    } else { // 中间
        self.divider.hidden = NO;
    }}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 分割线
    MHDivider *divider = [MHDivider divider];
    self.divider = divider;
    [self.contentView addSubview:divider];
    
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
}


@end
