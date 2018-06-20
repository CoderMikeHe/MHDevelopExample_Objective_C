//
//  CMHEmptyDataView.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHEmptyDataView.h"

@interface CMHEmptyDataView ()

/// imageView <图片>
@property (nonatomic , readwrite , weak) UIImageView *imageView;
/// tipsLabel <信息提示>
@property (nonatomic , readwrite , weak) UILabel *tipsLabel;
/// 重新加载
@property (nonatomic , readwrite , weak) UIButton *reloadButton;
/** 重新加载block */
@property (nonatomic , readwrite , copy) void(^reloadBlock)(void);
@end


@implementation CMHEmptyDataView

#pragma mark - Public Method
- (void)configEmptyViewWithType:(CMHEmptyDataViewType)type emptyInfo:(NSString *)emptyInfo errorInfo:(NSString *)errorInfo offsetTop:(CGFloat)offsetTop hasData:(BOOL)hasData hasError:(BOOL)hasError reloadBlock:(void(^)(void))reloadBlock{
    
    if (hasData) {  /// 有数据，则不需要显示占位图
        self.hidden = YES;
        [self removeFromSuperview];
        return;
    }
 
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).with.offset(offsetTop);
    }];
    
    self.reloadButton.hidden = MHObjectIsNil(reloadBlock);
    self.reloadBlock = reloadBlock;
    /// 没有数据的情况 1. 确实没有数据  2. 请求出错导致无数据
    self.hidden = NO;
    
    NSInteger random = [NSObject mh_randomNumber:0 to:1];
    UIImage *image = nil;
    if (hasError) { /// 请求出错 1. 网络问题  2. 服务器问题
#warning CMH TODO 后期增加网络请求再来处理，获取当前网络状态
        if (0) {  /// 无网络
            errorInfo = MHStringIsNotEmpty(errorInfo)?errorInfo:@"呀！网络正在开小差~";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"cmh_default_no_wifi_%ld",(long)random]];
        }else{    /// 服务器出错
            errorInfo = MHStringIsNotEmpty(errorInfo)?errorInfo:@"呜呜！服务器崩溃了~";
            image = [UIImage imageNamed:@"cmh_default_service_error"];
        }

        /// 赋值
        self.imageView.image = image;
        self.tipsLabel.text = errorInfo;
        return;
    }
    
    
    /// 无数据
    switch (type) {
        case CMHEmptyDataViewTypeDefault:  /// 默认情况
            {
                emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"哇喔！空空如也~";
                image = [UIImage imageNamed:[NSString stringWithFormat:@"cmh_default_empty_data_%ld",(long)random]];
            }
            break;
        case CMHEmptyDataViewTypeBuyGoods:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"没买到心仪的宝贝\n去首页逛逛吧～";
            image = [UIImage imageNamed:@"cmh_default_buy_goods"];
        }
            break;
        case CMHEmptyDataViewTypeSoldGoods:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"你的商品无人问津\n分享到朋友圈吆喝一下～";
            image = [UIImage imageNamed:@"cmh_default_sold_goods"];
        }
            break;
        case CMHEmptyDataViewTypePublishGoods:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"赶紧找出家里的闲置上传吧\n发布出来可以换钱哦～";
            image = [UIImage imageNamed:@"cmh_default_publish_goods"];
        }
            break;
        case CMHEmptyDataViewTypeCollectGoods:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"你还没有收藏相关商品\n赶快去逛逛吧～";
            image = [UIImage imageNamed:@"cmh_default_collect_goods"];
        }
            break;
        case CMHEmptyDataViewTypeGoodsDetail:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"这个商品不见了\n换一个商品再看看～";
            image = [UIImage imageNamed:@"cmh_default_goods_detail"];
        }
            break;
        case CMHEmptyDataViewTypeOrderDetail:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"暂无订单消息，去首页逛逛吧～";
            image = [UIImage imageNamed:@"cmh_default_order_detail"];
        }
            break;
        case CMHEmptyDataViewTypeSearchGoods:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"这是一道超岗题\n换一个关键词看看～";
            image = [UIImage imageNamed:@"cmh_default_search_no_result"];
        }
            break;
        case CMHEmptyDataViewTypeAddress:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"添加地址信息，下单更快捷～";
            image = [UIImage imageNamed:@"cmh_default_my_address"];
        }
            break;
        case CMHEmptyDataViewTypeRedPocket:
        {
            emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"您还没有可用的红包哦～";
            image = [UIImage imageNamed:@"cmh_default_red_pocket"];
        }
            break;
            
        default:
            {
                emptyInfo = MHStringIsNotEmpty(emptyInfo)?emptyInfo:@"哇喔！空空如也~";
                image = [UIImage imageNamed:[NSString stringWithFormat:@"cmh_default_empty_data_%ld",(long)random]];
            }
            break;
    }
    
    /// 赋值
    self.imageView.image = image;
    self.tipsLabel.text = emptyInfo;
}


#pragma mark - Private Method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 事件处理Or辅助方法
- (void)_reloadBtnDidClicked:(UIButton *)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !self.reloadBlock?:self.reloadBlock();
    });
}
#pragma mark - Private Method
- (void)_setup{
    self.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4"];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    /// imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self addSubview:imageView];
    
    /// tipsLabel
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsLabel.text = nil;
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel = tipsLabel;
    [self addSubview:tipsLabel];
    
    /// reloadButton
    UIButton * reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
    reloadButton.titleLabel.font =[UIFont systemFontOfSize:15.f];
    [reloadButton setTitleColor:CMH_MAIN_TINTCOLOR forState:UIControlStateNormal];
    [reloadButton setTitle:@"重新连接" forState:UIControlStateNormal];
    reloadButton.layer.cornerRadius = 4.f;
    reloadButton.layer.borderColor = CMH_MAIN_TINTCOLOR.CGColor;
    reloadButton.layer.borderWidth = 1.f;
    reloadButton.adjustsImageWhenHighlighted = YES;
    [reloadButton addTarget:self action:@selector(_reloadBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.reloadButton = reloadButton;
    [self addSubview:reloadButton];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipsLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 34));
    }];
}


@end
