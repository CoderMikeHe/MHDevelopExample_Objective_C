//
//  CMHExample06ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample06ViewController.h"

@interface CMHExample06ViewController ()
/// remoteLabel
@property (nonatomic , readwrite , weak) UILabel *remoteLabel;
/// localLabel
@property (nonatomic , readwrite , weak) UILabel *localLabel ;
/// remoteView
@property (nonatomic , readwrite , weak) UIImageView *remoteView;
/// localView
@property (nonatomic , readwrite , weak) UIImageView *localView;

/// 清除缓存
@property (nonatomic , readwrite , strong) UIBarButtonItem *clearItem;
@end

@implementation CMHExample06ViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 是否需要在控制器viewDidLoad后请求远程数据，默认 YES
        /// YES : 子类可以重写 requestRemoteData ，系统会在 viewDidLoad后请求远程数据 自动调用  requestRemoteData
        /// NO : 子类可以重写 requestRemoteData ，但是子类需要在子类的ViewDidLoad里面 手动调用 requestRemoteData
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
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
}

#pragma mark - Override
/// 基础配置 （PS：子类可以重写，且不需要在ViewDidLoad中手动调用，但是子类重写必须调用 [super configure]）
- (void)configure{
    [super configure];
    
    /// 开发者可以在这里配置一些基础数据，比如 `设置界面` 显示的静态数据
    /// 也可以获取一些本地数据库的数据
    
    /// 获取本地数据
    [self fetchLocalData];
    
    
    /// 如果self.shouldRequestRemoteDataOnViewDidLoad = NO;我们可以手动调用requestRemoteData，具体看场景咯
    /// [self requestRemoteData];
    
}

/// 请求远程数据，现实开发中我们一般需要请求网络数据来配置界面，显示，子类重写覆盖即可
- (void)requestRemoteData{
    /// sub class can override ， 但不需要在ViewDidLoad中手动调用 ，依赖`shouldRequestRemoteDataOnViewDidLoad = YES` 且不需要调用 super， 直接重写覆盖即可
    
    /// TEST : 模拟网络加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *urlStr = [NSObject mh_randomNumber:0 to:1] > 0 ? @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4212173360,2979120788&fm=27&gp=0.jpg" :@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=146409975,692268348&fm=27&gp=0.jpg";
        
        [self.remoteView yy_setImageWithURL:[NSURL URLWithString:urlStr] placeholder:MHImageNamed(@"placeholder_image") options:CMHWebImageOptionAutomatic completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            /// 将图片存在本地
            [[YYCache sharedCache] setObject:image forKey:CMHExample06RemoteImageCacheKey withBlock:^{
                NSLog(@"+++++ 图片保存到本地 +++++");
            }];
        }];
        
        
    });
    
}

/// 获取本地数据
- (UIImage *)fetchLocalData{
    /// sub class can override ，且不用调用 super， 直接重写覆盖
    @weakify(self);
    /// 异步
    [[YYCache sharedCache] objectForKey:CMHExample06RemoteImageCacheKey withBlock:^(NSString * _Nonnull key, UIImage *  _Nonnull object) {
        @strongify(self);
        // 子线程执行任务（比如获取较大数据）
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新 神马的
            self.localView.image = object;
            
            self.navigationItem.rightBarButtonItem = MHObjectIsNil(object)?nil:self.clearItem;
            
        });
    }];
    return nil;
}


#pragma mark - 事件处理Or辅助方法
- (void)_clearLocalCache{
    /// 清除掉缓存
    [MBProgressHUD mh_showProgressHUD:@"清除中..." addedToView:self.view];
    @weakify(self);
    
    [[YYCache sharedCache] removeObjectForKey:CMHExample06RemoteImageCacheKey withBlock:^(NSString * _Nonnull key) {
        @strongify(self);
        // 子线程执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD mh_hideHUDForView:self.view];
            
            [MBProgressHUD mh_showTips:@"清除成功" addedToView:self.view];
            
            /// 重置数据
            [self fetchLocalData];
        });
    }];
    
}
#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example06";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    /// https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4212173360,2979120788&fm=27&gp=0.jpg 《吴亦凡》
    /// https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=146409975,692268348&fm=27&gp=0.jpg 《鹿晗》
    UIImageView *localView = [[UIImageView alloc] init];
    self.localView = localView;
    [self.view addSubview:localView];
    
    UILabel *localLabel = [[UILabel alloc] init];
    localLabel.textAlignment = NSTextAlignmentCenter;
    localLabel.textColor = MHColorFromHexString(@"#333333");
    localLabel.text = @"上面👆是获取本地图片";
    [self.view addSubview:localLabel];
    self.localLabel = localLabel;
    
    
    UILabel *remoteLabel = [[UILabel alloc] init];
    remoteLabel.textAlignment = NSTextAlignmentCenter;
    remoteLabel.textColor = MHColorFromHexString(@"#333333");
    remoteLabel.text = @"下面👇是请求网络图片";
    [self.view addSubview:remoteLabel];
    self.remoteLabel = remoteLabel;
    
    UIImageView *remoteView = [[UIImageView alloc] init];
    self.remoteView = remoteView;
    [self.view addSubview:remoteView];
    
    /// 基础设置
    localView.layer.cornerRadius = remoteView.layer.cornerRadius = 10;
    localView.layer.masksToBounds = remoteView.layer.masksToBounds = YES;
    localView.layer.borderWidth = remoteView.layer.borderWidth = 2;
    localView.layer.borderColor = remoteView.layer.borderColor = [UIColor grayColor].CGColor;
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    CGSize size = CGSizeMake(200, 200);
    
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).with.offset(-5);
    }];
    
    [self.remoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).with.offset(5);;
    }];
    
    
    [self.localView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.localLabel.mas_top).with.offset(-5);
        make.size.mas_equalTo(size);
        make.centerX.equalTo(self.view);
    }];
    
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remoteLabel.mas_bottom).with.offset(5);;
        make.size.mas_equalTo(size);
        make.centerX.equalTo(self.view);
    }];
    
}

#pragma mark - Setter & Getter
- (UIBarButtonItem *)clearItem{
    if (_clearItem == nil) {
        _clearItem  = [UIBarButtonItem mh_systemItemWithTitle:@"清除缓存" titleColor:UIColor.whiteColor imageName:nil target:self selector:@selector(_clearLocalCache) textType:YES];
    }
    return _clearItem ;
}
@end
