//
//  SUGoodsCell.m
//  SenbaUsed
//
//  Created by shiba_iOSRB on 16/7/26.
//  Copyright © 2016年 曾维俊. All rights reserved.
//

#import "SUGoodsCell.h"
#import "SUGoodsImageCell.h"
//#import "SUGoodsHomeItemViewModel.h"


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


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

/// viewModle
//@property (nonatomic, readwrite, strong) SUGoodsHomeItemViewModel *viewModel;
@end

@implementation SUGoodsCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        /// fix 长按cell导致子控件背景色改变的bug
        self.extraFee.backgroundColor = SUGlobalPinkColor;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{ 
    [super setSelected:selected animated:animated];

}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /// 头像
    /// 这种方法不能设置BorderWidth
//    self.userHeadImageView.layer.masksToBounds = NO;
//    self.userHeadImageView.aliCornerRadius = 18;
    /// 优化性能  避免离屏渲染
    [self.userHeadImageView zy_cornerRadiusRoundingRect];
    [self.userHeadImageView zy_attachBorderWidth:.5f color:MHColorFromHexString(@"#EBEBEB")];
    
    /// 昵称
    self.userNameLabel.font = MHRegularFont_14;
    self.userNameLabel.textColor = MHGlobalBlackTextColor;
    
    /// 发布时间
    self.publishTimeLabel.font = MHRegularFont_12;
    self.publishTimeLabel.textColor = MHColorFromHexString(@"#9CA1B2");
    self.publishTimeLabel.backgroundColor = MHGlobalWhiteTextColor;
    
    /// 卖价
    self.priceLabel.font = [UIFont systemFontOfSize:18];
    self.priceLabel.textColor = MHColorFromHexString(@"#FC0000");
    
    /// 原价
    self.oldPriceLabel.font = MHRegularFont_12;
    self.oldPriceLabel.textColor = SUGlobalShadowGrayTextColor;
    self.oldPriceLabel.backgroundColor  = [UIColor whiteColor];
    
    /// 运费
    self.extraFee.backgroundColor = SUGlobalPinkColor;
    self.extraFee.textColor = [UIColor whiteColor];

    /// 宝贝数量
    self.countLabel.font = MHRegularFont_12;
    self.countLabel.textColor = MHColorFromHexString(@"9DA2B3");
    self.countLabel.backgroundColor  = [UIColor whiteColor];
    
    /// 商品主题
    self.goodsTitleLabel.font = MHMediumFont(15.0f);
    self.goodsTitleLabel.backgroundColor = [UIColor whiteColor];
    self.goodsTitleLabel.textColor = MHGlobalShadowBlackTextColor;
    
    /// 商品描述
    self.contentLabel.backgroundColor  = [UIColor whiteColor];
    self.contentLabel.font = MHRegularFont_14;
    self.contentLabel.textColor = MHGlobalShadowBlackTextColor;
    
    /// 定位
//    self.GPSBtn.setTitleColorSU(RGBV(0x9CA1B2), UIControlStateNormal).setFontSU(MHRegularFont_12);
//    self.GPSBtn.backgroundColor = [UIColor whiteColor];
// 
//    [self.optimalProductCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SUHomeCollectionViewCell class]) bundle:nil]
//                        forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
//    self.optimalProductCollectionView.dataSource = self;
//    self.optimalProductCollectionView.delegate = self;
//    self.optimalProductCollectionView.contentInset = UIEdgeInsetsMake(0, , 0, APPLICATION_MARGIN);
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 10;
    CGFloat itemWH = 88.0f;
    self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    
    self.optimalProductCollectionView.backgroundColor   = [UIColor whiteColor];
    self.userNameLabel.backgroundColor                  = [UIColor whiteColor];
    
    
    self.userHeadImageView.backgroundColor              = [UIColor whiteColor];
    self.replyBtn.backgroundColor                       = [UIColor whiteColor];
    
    
    // --- Action
//    @weakify(self);
//    [[self.GPSBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(UIButton *sender) {
//         @strongify(self);
//         ///
//         NSLog(@"---位置被点击---");
//         [self.viewModel.locationDidClickedSuject sendNext:self.viewModel];
//     }];
//    
//    self.userHeadImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *avatarTapGr = [[UITapGestureRecognizer alloc] init];
//    [self.userHeadImageView addGestureRecognizer:avatarTapGr];
//    [avatarTapGr.rac_gestureSignal subscribeNext:^(id x) {
//        NSLog(@"---头像被点击---");
//        [self.viewModel.avatarDidClickedSuject sendNext:self.viewModel];
//    }];
// 
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
//    [self.optimalProductCollectionView addGestureRecognizer:singleTap];
//    [singleTap.rac_gestureSignal subscribeNext:^(id x) {
//        @strongify(self);
//        NSLog(@"---UICollectionView---");
//        [self.viewModel.pictureDidClickedSuject sendNext:self.viewModel];
//    }];
    
    self.backgroundColor = [UIColor whiteColor];
}


//#pragma mark - bind data
//- (void)bindViewModel:(SUGoodsHomeItemViewModel *)viewModel
//{
//    self.viewModel = viewModel;
//    
//    /// 头像
//    [MHWebImageTool setImageWithURL:viewModel.avatar placeholderImage:placeholderUserIcon() imageView:self.userHeadImageView];
//    
//    /// 昵称
//    self.userNameLabel.text = viewModel.nickname;
//    self.realNameIcon.hidden = !viewModel.iszm;
//    /// 发布时间
//    self.publishTimeLabel.text = viewModel.publishTime;
//    
//    /// 照片
//    self.imageURLs = viewModel.imageURLs;
//    
//    /// 卖价
//    self.priceLabel.attributedText = viewModel.price;
//    self.priceLabel.frame = viewModel.priceLalelFrame;
//    
//    /// 原价
//    self.oldPriceLabel.attributedText = viewModel.oPrice;
//    self.oldPriceLabel.frame = viewModel.oPriceLalelFrame;
//    
//    /// 运费
//    self.extraFee.text = viewModel.freightExplain;
//    self.extraFee.frame = viewModel.freightageLalelFrame;
//    [self.extraFee hyb_addCornerRadius:2];
//    /// 数量
//    self.countLabel.text = viewModel.number;
//    
//    /// 主题
//    self.goodsTitleLabel.attributedText = viewModel.titleAttr;
//    
//    /// 描述
//    self.contentLabel.text = viewModel.goodsDescription;
//    
//    /// 位置
//    [self.GPSBtn setTitle:viewModel.locationName forState:UIControlStateNormal];
//    
//    /// 留言数量
//    [self.replyBtn setAttributedTitle:viewModel.messages forState:UIControlStateNormal];
//
//}




#pragma mark - collectionVeiwDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUGoodsImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsImage" forIndexPath:indexPath];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]] placeholderImage:placeholderImage() options:SDWebImageRetryFailed|SDWebImageAllowInvalidSSLCertificates];
    return cell;
}

#pragma mark - Setter & Getter
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs {
    _imageURLs = imageURLs;
    self.optimalProductCollectionView.contentOffset = CGPointMake(-SUGlobalViewLeftOrRightMargin, 0);
    [self.optimalProductCollectionView reloadData];
}
@end
