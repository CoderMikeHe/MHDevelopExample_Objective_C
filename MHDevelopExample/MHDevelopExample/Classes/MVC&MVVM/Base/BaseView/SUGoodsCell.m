//
//  SUGoodsCell.m
//  SenbaUsed
//
//  Created by shiba_iOSRB on 16/7/26.
//  Copyright © 2016年 曾维俊. All rights reserved.
//

//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
#import "SUGoodsFrame.h"
//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore


#import "SUGoodsCell.h"
#import "SUGoodsImageCell.h"


#import "SUGoodsItemViewModel.h"


@interface SUGoodsCell()<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
/// 图片
@property (nonatomic, strong) NSArray<NSString *> *imageURLs;

//Real-name authentication
@property (weak, nonatomic) IBOutlet UIImageView *realNameIcon;

/// 头像按钮
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
/// 用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/// 商品照片
@property (weak, nonatomic) IBOutlet UICollectionView *optimalProductCollectionView;
/// 原价
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
/** 商品标题 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
/// 描述内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/// 运费
@property (weak, nonatomic) IBOutlet UILabel *extraFee;
/// 数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/// 回复按钮
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
/// 位置按钮
@property (weak, nonatomic) IBOutlet UIButton *GPSBtn;
/// 分割线
@property (weak, nonatomic) IBOutlet UIView *sepLineView;
/// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
/// 商品图片布局
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

/// 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;

/// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
/// viewModle
@property (nonatomic, readwrite, strong) SUGoodsItemViewModel *viewModel;
//// 以上 MVVM使用的场景，如果使用MVC的请自行ignore

/// 以下 MVVM With RAC使用的场景，如果使用其他的的请自行ignore

/// 显示HUD
@property (nonatomic, readwrite, assign) BOOL showHUD;

/// 以上 MVVM With RAC使用的场景，如果使用其他的的请自行ignore
@end

@implementation SUGoodsCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        /// FIXED: 长按cell导致子控件背景色改变的bug
        self.extraFee.backgroundColor = SUGlobalPinkColor;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{ 
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    /// 头像
    /// 这种方法不能设置BorderWidth
//    self.userHeadImageView.layer.masksToBounds = NO;
//    self.userHeadImageView.aliCornerRadius = 18;
    /// 优化性能  避免离屏渲染
    [self.userHeadImageView zy_cornerRadiusRoundingRect];
    [self.userHeadImageView zy_attachBorderWidth:.5f color:MHColorFromHexString(@"#EBEBEB")];
    /// 运费
    self.extraFee.backgroundColor = SUGlobalPinkColor;
    self.extraFee.textColor = [UIColor whiteColor];
    self.extraFee.layer.cornerRadius = 2;
#warning COderMikeHe FIXME：此处需要优化，避免离屏渲染
    self.extraFee.layer.masksToBounds = YES;

    /// UICollectionView注册cell
    [self.optimalProductCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SUGoodsImageCell class]) bundle:nil]
                        forCellWithReuseIdentifier:NSStringFromClass([SUGoodsImageCell class])];
    self.optimalProductCollectionView.dataSource = self;
    self.optimalProductCollectionView.delegate = self;
    self.optimalProductCollectionView.contentInset = UIEdgeInsetsMake(0 , SUGlobalViewLeftOrRightMargin , 0, SUGlobalViewLeftOrRightMargin);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 10;
    CGFloat itemWH = 88.0f;
    self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    self.optimalProductCollectionView.backgroundColor   = [UIColor whiteColor];

    // --- add Action ---
    //// 使用MVC 和 MVVM without RAC 的事件回调
    [self _addActionDealForMVCOrMVVMWithoutRAC];
    
    
    
    //// MVVM with RAC 的事件回调
    [self _addActionDealForMVVMWithRAC];
    
    
    //// 以下 MVVM With RAC 模式的的数据绑定 如果使用其他的模式的请自行ignore
    @weakify(self);
    
    /// 按钮选中状态
    [RACObserve(self, viewModel.goods.isLike).deliverOnMainThread.distinctUntilChanged subscribeNext:^(NSNumber *isLike) {
        @strongify(self);
        if (!self.showHUD) return ;
        self.thumbBtn.selected = isLike.boolValue;
        NSString *tips = (isLike.boolValue)?@"收藏商品成功":@"取消收藏商品";
        [MBProgressHUD mh_showTips:tips];
        
    }];
    /// 监听点赞数据
    [RACObserve(self, viewModel.goods.likes).deliverOnMainThread.distinctUntilChanged
     subscribeNext:^(NSString * likes) {
         @strongify(self);
         [self.thumbBtn setTitle:likes forState:UIControlStateNormal];
         
     }];
    //// 以下 MVVM With RAC 的事件回调的使用的场景，如果使用其他的模式的请自行ignore
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(SUGoodsItemViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    self.showHUD = NO;
    
    
    /// 头像
    [MHWebImageTool setImageWithURL:viewModel.goods.avatar placeholderImage:placeholderUserIcon() imageView:self.userHeadImageView];
    
    /// 昵称
    self.userNameLabel.text = viewModel.goods.nickName;
    self.realNameIcon.hidden = !viewModel.goods.iszm;
    /// 发布时间
    self.publishTimeLabel.text = viewModel.goodsPublishTime;
    
    /// 照片
    self.imageURLs = viewModel.imagesUrlStrings;
    
    /// 卖价
    self.priceLabel.attributedText = viewModel.goodsPriceAttributedString;
    self.priceLabel.frame = viewModel.priceLalelFrame;
    
    /// 原价
    self.oldPriceLabel.attributedText = viewModel.goodsOPriceAttributedString;
    self.oldPriceLabel.frame = viewModel.oPriceLalelFrame;
    
    /// 运费
    self.extraFee.text = viewModel.freightExplain;
    self.extraFee.frame = viewModel.freightageLalelFrame;
    [self.extraFee hyb_addCornerRadius:2];
    /// 数量
    self.countLabel.text = viewModel.number;
    
    /// 主题
    self.goodsTitleLabel.attributedText = viewModel.goodsTitleAttributedString;
    
    /// 描述
    self.contentLabel.text = viewModel.goods.goodsDescription;
    
    /// 位置
    [self.GPSBtn setTitle:viewModel.goods.locationAreaName forState:UIControlStateNormal];
    
    /// 回复数
    [self.replyBtn setTitle:viewModel.goods.messages forState:UIControlStateNormal];
    
    /// 点赞数
    [self.thumbBtn setTitle:viewModel.goods.likes forState:UIControlStateNormal];
    self.thumbBtn.selected = viewModel.goods.isLike;

}
//// 以上 MVVM使用的场景，如果使用MVC的请自行ignore







//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
- (void)setGoodsFrame:(SUGoodsFrame *)goodsFrame{
    _goodsFrame = goodsFrame;
    SUGoods *goods = goodsFrame.goods;
    
    /// 商品头像
    [MHWebImageTool setImageWithURL:goods.avatar placeholderImage:placeholderUserIcon() imageView:self.userHeadImageView];
    self.realNameIcon.hidden = !goods.iszm;
    
    /// 用户昵称
    self.userNameLabel.text = goods.nickName;
    
    /// 发布时间
    self.publishTimeLabel.text = goods.goodsPublishTime;
    
    /// 商品价格
    self.priceLabel.attributedText = goods.goodsPriceAttributedString;
    self.priceLabel.frame = goodsFrame.priceLalelFrame;
    
    /// 商品原价
    self.oldPriceLabel.attributedText = goods.goodsOPriceAttributedString;
    self.oldPriceLabel.frame = goodsFrame.oPriceLalelFrame;
    
    /// 商品包邮 运费情况
    self.extraFee.text = goods.freightExplain;
    self.extraFee.frame = goodsFrame.freightageLalelFrame;
    /// 商品图片
    self.imageURLs = goods.imagesUrlStrings;

    /// 商品数量
    self.countLabel.text = [NSString stringWithFormat:@"数量 %@",goods.number];
    
    /// 主题
    self.goodsTitleLabel.attributedText = goods.goodsTitleAttributedString;
    
    /// 描述
    self.contentLabel.text = goods.goodsDescription;
    
    /// 区域
    [self.GPSBtn setTitle:goods.locationAreaName forState:UIControlStateNormal];
    
    /// 回复数
    [self.replyBtn setTitle:goods.messages forState:UIControlStateNormal];
    
    /// 点赞数
    [self.thumbBtn setTitle:goods.likes forState:UIControlStateNormal];
    self.thumbBtn.selected = goods.isLike;

}
//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore



#pragma mark - 事件处理
//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/// 事件处理 我这里使用 block 来回调事件 （PS：大家可以自行决定）
- (void)_addActionDealForMVCOrMVVMWithoutRAC
{
    /// 头像被点击
    @weakify(self);
    [self.userHeadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        !self.avatarClickedHandler?:self.avatarClickedHandler(self);
    }]];
    
    /// 位置被点击
    [self.GPSBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.locationClickedHandler?:self.locationClickedHandler(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    /// 回复按钮被点击
    [self.replyBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.replyClickedHandler?:self.replyClickedHandler(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    /// 收藏按钮被点击
    [self.thumbBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.thumbClickedHandler?:self.thumbClickedHandler(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    /// 图片被点击
    [self.optimalProductCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        !self.pictureViewClickedHandler?:self.pictureViewClickedHandler(self);
    }]];
}
//// 以上 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore





//// 以下 MVVM With RAC 的事件回调的使用的场景，如果使用其他的模式的请自行ignore
/// 事件处理 我这里使用 block 来回调事件 （PS：大家可以自行决定）
- (void)_addActionDealForMVVMWithRAC
{
    @weakify(self);
    /// 头像
    /// Fixed : 这个方法会导致上面的使用 MVC 或者 MVVM without RAC 情况的头像点击失效 但是理论上是绝对不会出现这两种模式共存的情况的 这里笔者只是为了做区分而已
    UITapGestureRecognizer *avatarTapGr = [[UITapGestureRecognizer alloc] init];
    [self.userHeadImageView addGestureRecognizer:avatarTapGr];
    [avatarTapGr.rac_gestureSignal
    subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.didClickedAvatarSubject sendNext:self.viewModel];
        ///  MVC 或者 MVVM without RAC 有效
        !self.avatarClickedHandler?:self.avatarClickedHandler(self);
    }];
    
    /// 地址
    [[self.GPSBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         [self.viewModel.didClickedLocationSubject sendNext:self.viewModel];
     }];

    /// 回复
    [[self.replyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         [self.viewModel.didClickedReplySubject sendNext:self.viewModel];
     }];

   
    /// 收藏按钮
    [[self.thumbBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         /// 执行
         self.thumbBtn.enabled = NO;
         self.showHUD = YES;
         [MBProgressHUD mh_showProgressHUD:@"Loading..."];
         @weakify(self)
         [[[self.viewModel.operationCommand
            execute:self.viewModel]
           deliverOnMainThread]
          subscribeCompleted:^{
              @strongify(self)
              self.thumbBtn.enabled = YES;
              self.showHUD = NO;
          }];
         
     }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    [self.optimalProductCollectionView addGestureRecognizer:singleTap];
    [singleTap.rac_gestureSignal
     subscribeNext:^(id x) {
        @strongify(self);
        /// MVC 或者 MVVM without RAC 有效
        !self.pictureViewClickedHandler?:self.pictureViewClickedHandler(self);
    }];

}
//// 以上 MVVM With RAC 的事件回调的使用的场景，如果使用其他的模式的请自行ignore















////////////////// 以下为UI代码，不必过多关注 ///////////////////
#pragma mark - collectionVeiwDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUGoodsImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SUGoodsImageCell class]) forIndexPath:indexPath];
    [MHWebImageTool setImageWithURL:self.imageURLs[indexPath.row] placeholderImage:placeholderImage() imageView:cell.imageView];
    return cell;
}
#pragma mark - Setter & Getter
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs
{
    _imageURLs = imageURLs;
    /// 归位
    self.optimalProductCollectionView.contentOffset = CGPointMake(-SUGlobalViewLeftOrRightMargin, 0);
    [self.optimalProductCollectionView reloadData];
}
@end
