//
//  CMHExample21ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample21ViewController.h"
#import "CMHSearchTitleView.h"
#import "CMHSearchHistoryCell.h"
#import "CMHSearchHistoryHeaderView.h"
#import <UICollectionViewLeftAlignedLayout/UICollectionViewLeftAlignedLayout.h>

/// 最多只能出现30个历史数据
static NSUInteger const CMHSearchGoodsHistoryMaxCount  = 30;

@interface CMHExample21ViewController ()<UITextFieldDelegate,CMHSearchHistoryHeaderViewDelegate>
/// titleView
@property (nonatomic , readwrite , weak) CMHSearchTitleView *titleView;
@end

@implementation CMHExample21ViewController
/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 左对齐布局
        UICollectionViewLeftAlignedLayout *flow = [[UICollectionViewLeftAlignedLayout alloc] init];
        flow.minimumInteritemSpacing = 10;
        flow.minimumLineSpacing = 10;
        flow.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        flow.headerReferenceSize = CGSizeMake(MH_SCREEN_WIDTH, 44.0f);
        self.collectionViewLayout = flow;

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /// 成为第一响应者
    [self.titleView.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 成为第一响应者
    [self.titleView.textField resignFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
    
    /// 注册cell
    [self.collectionView registerClass:CMHSearchHistoryCell.class forCellWithReuseIdentifier:@"CMHSearchHistoryCell"];
    [self.collectionView registerClass:[CMHSearchHistoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CMHSearchHistoryHeaderView class])];
}

#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 获取本地数据
    [self fetchLocalData];
}

- (id)fetchLocalData{
    @weakify(self);
    [[YYCache sharedCache] objectForKey:CMHSearchFarmsHistoryCacheKey withBlock:^(NSString * _Nonnull key, NSArray <NSCoding>   * _Nullable  object) {
        @strongify(self);
        // 子线程执行任务（比如获取较大数据）
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新 神马的
            [self.dataSource addObjectsFromArray:object];
            [self.collectionView reloadData];
        });
    }];
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CMHSearchHistoryCell" forIndexPath:indexPath];
}

- (void)configureCell:(CMHSearchHistoryCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell configureModel:object];
}

#pragma mark - 事件处理Or辅助方法
-(void)_closeAction{
    /// 关掉键盘
    [self.titleView.textField resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 判断 是Push还是Present进来的，
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)_addSearchHistorySearchText:(NSString *)searchText{
    
    NSMutableArray *tempArray = self.dataSource.mutableCopy;
    
    /// 先判断是否已经在之前的历史列表中
    NSString *findKeyword = nil;
    for (NSString *tempStr in tempArray) {
        if ([tempStr isEqualToString:searchText]) {
            findKeyword = searchText;
            break;
        }
    }
    if (findKeyword) {
        /// 删除
        [tempArray removeObject:findKeyword];
        
        /// 插入到最前面
        [tempArray prependObject:findKeyword];
        
    }else{
        /// 插入到最前面
        [tempArray prependObject:searchText];
    }
    
    /// 只允许20个历史记录
    if (tempArray.count > CMHSearchGoodsHistoryMaxCount) {
        tempArray = [tempArray subarrayWithRange:NSMakeRange(0, CMHSearchGoodsHistoryMaxCount)].mutableCopy;
    }
    /// 缓存
    [[YYCache sharedCache] setObject:tempArray.copy forKey:CMHSearchFarmsHistoryCacheKey withBlock:^{
        NSLog(@" --- insert search searchText success --- ");
    }];
    
    /// 回调数据 必须要等dismiss掉，在回调数据
    !self.callback?:self.callback(searchText);
    
    /// 退出控制器
    [self _closeAction];
}

- (void)_deleteSearchHistory{
    
    [self.dataSource removeAllObjects];
    
    /// 删除
    [[YYCache sharedCache] removeObjectForKey:CMHSearchFarmsHistoryCacheKey withBlock:^(NSString * _Nullable key) {
        NSLog(@"--- delete all search history success ---");
    }];
    
    [self reloadData];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataSource[indexPath.item];
    CGFloat itemW = [text mh_sizeWithFont:MHRegularFont_12].width + 24;
    return CGSizeMake(itemW, 30);
}

#pragma mark - UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CMHSearchHistoryHeaderView *historyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CMHSearchHistoryHeaderView class]) forIndexPath:indexPath];
        /// 事件处理
        historyView.delegate = self;
        return historyView;
    }else{
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    /// 增加搜索条件
    [self _addSearchHistorySearchText:self.dataSource[indexPath.item]];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /// 关掉键盘
    [self.titleView.textField resignFirstResponder];
}

#pragma mark - CMHSearchHistoryHeaderViewDelegate
- (void)searchHistoryHeaderViewDidClickedDeleteItem:(CMHSearchHistoryHeaderView *)searchHistoryHeaderView{
    /// 删除历史条件
    [self _deleteSearchHistory];
}


#pragma mark - UITextFieldDelegate
// called when text changes (including clear)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (MHStringIsNotEmpty(textField.text)) {
        [self _addSearchHistorySearchText:textField.text];
    }else{
        textField.text = textField.placeholder;
        /// 加点延迟  让用户看到你的 搜索内容
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _addSearchHistorySearchText:textField.text];
        });
    }
    
    return YES;
}


#pragma mark - 初始化
- (void)_setup{
    self.collectionView.alwaysBounceVertical = YES;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    /// 去掉左侧按钮
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_customItemWithTitle:@"取消" titleColor:CMH_MAIN_TINTCOLOR imageName:nil target:self selector:@selector(_closeAction) contentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    CMHSearchTitleView *titleView = [[CMHSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, (MH_SCREEN_WIDTH - 26 - 44), 28)];
    titleView.textField.delegate = self;
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    
    NSArray *placeholders = @[@"CoderMikeHe",@"勒布朗.詹姆斯",@"凯里.欧文",@"斯蒂芬.库里",@"威少",@"詹姆斯.哈登",@"克里斯.保罗"];
    self.titleView.textField.placeholder = placeholders[[NSObject mh_randomNumber:0 to:6]];
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter



@end
