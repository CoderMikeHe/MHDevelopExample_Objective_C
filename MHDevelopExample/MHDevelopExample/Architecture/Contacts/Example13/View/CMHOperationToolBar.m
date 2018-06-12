//
//  CMHOperationToolBar.m
//  UTrading
//
//  Created by lx on 2018/4/20.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//

#import "CMHOperationToolBar.h"

@interface CMHOperationToolBar ()
/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(CMHOperationToolBarType);
/// 全选btn
@property (nonatomic , readwrite , weak) CMHOperationToolBarItem *checkAllItem;
/// 删除
@property (nonatomic , readwrite , weak) CMHOperationToolBarItem *deleteItem;
/// 转让
@property (nonatomic , readwrite , weak) CMHOperationToolBarItem *transferItem;
/// 协作
@property (nonatomic , readwrite , weak) CMHOperationToolBarItem *cooperationItem;
/// showType
@property (nonatomic , readwrite , assign) CMHOperationToolBarShowType showType;
@end;


@implementation CMHOperationToolBar

- (instancetype)initWithShowType:(CMHOperationToolBarShowType)showType selectedOperationType:(void (^)(CMHOperationToolBarType))completed{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.completionCallBack = completed;
        self.showType = showType;
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}



#pragma mark - User Action
- (void)_buttonDidClicked:(CMHOperationToolBarItem *)sender{
    /// 按钮点击
    if (sender == self.checkAllItem) {
        sender.selected = !sender.isSelected;
    }
    
    !self.completionCallBack?:self.completionCallBack(sender.tag);
}




#pragma mark - Private Method
- (void)_setup{
    self.layer.shadowColor =  [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor; //阴影颜色
    // width表示阴影与x的便宜量,height表示阴影与y值的偏移量
    self.layer.shadowOffset = CGSizeMake(0, -1);
    // 阴影透明度,默认为0则看不到阴影
    self.layer.shadowOpacity = 0.4;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    /// 全选
    self.checkAllItem = [self _addItemWithTitle:@"全选" selectedTitle:@"取消" image:@"footprint_select" selectedImage:@"footprint_select_press" type:CMHOperationToolBarTypeCheckAll];
    
    /// 转让
    if (self.showType == CMHOperationToolBarShowTypeFootmark) {
        self.cooperationItem = [self _addItemWithTitle:@"协作" selectedTitle:nil image:@"footprint_cooperation" selectedImage:nil type:CMHOperationToolBarTypeCooperation];
        
        self.transferItem = [self _addItemWithTitle:@"转让" selectedTitle:nil image:@"uf_footprint_transfer" selectedImage:nil type:CMHOperationToolBarTypeTransfer];
        
    }
    
    /// 删除
    self.deleteItem = [self _addItemWithTitle:@"删除" selectedTitle:nil image:@"album_trash_black" selectedImage:nil type:CMHOperationToolBarTypeDelete];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    CGFloat width = MH_SCREEN_WIDTH / self.subviews.count;
    [self.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:width leadSpacing:0 tailSpacing:0];
    [self.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(54);
    }];
}


#pragma mark - 辅助方法
- (CMHOperationToolBarItem *)_addItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(NSString *)imageName selectedImage:(NSString *)selectedImageName type:(CMHOperationToolBarType)type{
    CMHOperationToolBarItem *button = [[CMHOperationToolBarItem alloc] init];
    [button setImage:MHImageNamed(imageName) forState:UIControlStateNormal];
    [button setImage:MHImageNamed(selectedImageName) forState:UIControlStateSelected];
    [button setTitleColor:MHColorFromHexString(@"#333333") forState:UIControlStateNormal];
    [button setTitleColor:MHColorFromHexString(@"#47BAFE") forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button addTarget:self action:@selector(_buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = type;
    [self addSubview:button];
    return button;
}

@end
