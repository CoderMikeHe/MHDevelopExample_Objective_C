//
//  CMHCoverSourceView.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHCoverSourceView.h"
#import "CMHSource.h"
@interface CMHCoverSourceView ()
/// coverView
@property (nonatomic , readwrite , weak) UIImageView *coverView;
/// 标题
@property (nonatomic , readwrite , weak) UIButton *titileBtn;
/// source
@property (nonatomic , readwrite , strong) CMHSource *source;

@end


@implementation CMHCoverSourceView
#pragma mark - Public Method
- (void)configureModel:(CMHSource *)source{
    self.source = source;
    NSString *title = MHStringIsNotEmpty(source.title)?source.title:@"点我，输入资源标题...";
    [self.titileBtn setTitle:title forState:UIControlStateNormal];
    [self.coverView yy_setImageWithURL:[NSURL URLWithString:source.coverUrl] placeholder:MHImageNamed(@"default_logo_16_9") options:CMHWebImageOptionAutomatic completion:NULL];
    
    
    /// 监听
    @weakify(self);
    [[[RACObserve(self, source.title) skip:1] distinctUntilChanged] subscribeNext:^(NSString *  _Nullable text) {
        @strongify(self);
        [self.titileBtn setTitle:MHStringIsNotEmpty(text)?text:@"点我，输入资源标题..." forState:UIControlStateNormal];
    }];
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
- (void)_titleBtnDidClicked:(UIButton *)sender{
    
    !self.titleCallback ? : self.titleCallback(self);
}

#pragma mark - Private Method
- (void)_setup{
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    /**
     http://img1.imgtn.bdimg.com/it/u=4187898496,3043946443&fm=27&gp=0.jpg
     http://img4.imgtn.bdimg.com/it/u=3964134380,1177908120&fm=27&gp=0.jpg
     http://img1.imgtn.bdimg.com/it/u=1175648843,2178002342&fm=27&gp=0.jpg
     http://img4.imgtn.bdimg.com/it/u=3818975264,3329086890&fm=27&gp=0.jpg
     http://img0.imgtn.bdimg.com/it/u=71343391,2567854601&fm=27&gp=0.jpg
     
     */
    /// 封面
    UIImageView *coverView = [[UIImageView alloc] init];
    coverView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    /// 标题
    UIButton *titileBtn = [[UIButton alloc] init];
    [titileBtn setTitle:@"点我，输入资源标题..." forState:UIControlStateNormal];
    [titileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titileBtn.titleLabel.font = MHMediumFont(18.0f);
    [self addSubview:titileBtn];
    self.titileBtn = titileBtn;
    [titileBtn addTarget:self action:@selector(_titleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.equalTo(self).with.offset(10);
        make.right.lessThanOrEqualTo(self).with.offset(-16);
    }];
    
}

@end
