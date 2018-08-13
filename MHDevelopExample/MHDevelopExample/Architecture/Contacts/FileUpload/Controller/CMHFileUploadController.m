//
//  CMHFileUploadController.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileUploadController.h"
#import "CMHCreateSourceController.h"
#import "CMHSource.h"
#import "CMHFileUploadCell.h"
#import "CMHFileUploadManager.h"


@interface CMHFileUploadController ()<CMHFileUploadCellDelegate>
@end

@implementation CMHFileUploadController


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

#pragma mark - 事件处理Or辅助方法
- (void)_createSource{
    /// 创建资源
    CMHCreateSourceController *createSource = [[CMHCreateSourceController alloc] initWithParams:nil];
    [self.navigationController pushViewController:createSource animated:YES];
}

/// 获取草稿数据
- (void)_fetchDraftDataFromDB{
    @weakify(self);
    [CMHSource fetchAllDrafts:^(NSArray * _Nullable array) {
        @strongify(self);
        [MBProgressHUD mh_hideHUDForView:self.view];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[self _reviseDraftsUploadStatus:array]];
        [self reloadData];
        [self _configureEmptyView];
    }];
}

//// 删除草稿文件
- (void)_deleteDraftFile:(NSInteger)index{
    
    /// 两种情况
    /// 1. 本地数据库
    /// 2. 服务器File
    CMHSource *source = self.dataSource[index];
    [self.dataSource removeObject:source];
    [self reloadData];
    
    /// 取消掉正在上传的数据
    [[CMHFileUploadManager sharedManager] cancelUpload:source.sourceId];

    /// 删除掉网上已经上传的文件片的数据
    [[CMHFileUploadManager sharedManager] deleteUploadedFile:source.sourceId];

    /// 从数据库里面删除
    [CMHSource removeSourceFromDB:source.sourceId complete:^(BOOL isSuccess) {
        [MBProgressHUD mh_showTips:[NSString stringWithFormat:@"删除草稿%@", isSuccess ? @"成功" : @"失败"]];
    }] ;

    /// 显示占位
    [self _configureEmptyView];
}


/// 配置占位图
- (void)_configureEmptyView{

    CGFloat offsetTop = (MH_SCREEN_HEIGHT - self.tableView.contentInset.top - self.tableView.contentInset.bottom ) * .5f - 40;
    [self.tableView cmh_configEmptyViewWithType:CMHEmptyDataViewTypeDefault emptyInfo:nil errorInfo:nil offsetTop:offsetTop hasData:self.dataSource.count>0 hasError:NO reloadBlock:NULL];
}

/// ------- 通知事件处理 ---------
/// 有资源保存到草稿
- (void)_saveSourceToDBSuccess:(NSNotification *)note{
    
    CMHSource *source = [note.userInfo valueForKey:CMHSaveSourceToDBSuccessInfoKey];
    
    /// 逆序遍历，删除存在草稿的数据
    /// CoderMikeHe Fixed Bug : 边遍历边删除： https://blog.csdn.net/zhangzhan_zg/article/details/38453305
    for (CMHSource *s in self.dataSource.reverseObjectEnumerator) {
        if ([s.sourceId isEqualToString:source.sourceId]) {
            [self.dataSource removeObject:s];
        }
    }
    /// 插入到数组第一个
    [self.dataSource insertObject:source atIndex:0];
    
    [self reloadData];
    
    /// 配置占位图
    [self _configureEmptyView];
}

/// 资源提交成功的通知
- (void)_fileUploadDidFinished:(NSNotification *)note{
    NSString *sourceId = note.userInfo[CMHFileUploadSourceIdKey];
    for (CMHSource *s in self.dataSource.reverseObjectEnumerator) {
        if ([s.sourceId isEqualToString:sourceId]) {
            [self.dataSource removeObject:s];
        }
    }
    [self reloadData];
    /// 配置占位图
    [self _configureEmptyView];
}

/// 资源上传进度改变的通知
- (void)_fileUploadProgressDidChanged:(NSNotification *)note{
    NSString *sourceId = note.userInfo[CMHFileUploadSourceIdKey];
    CGFloat progress = [note.userInfo[CMHFileUploadProgressDidChangedKey] doubleValue];
    
    NSInteger count = self.dataSource.count;
    for (NSInteger i = 0 ; i < count; i++) {
        CMHSource *s = self.dataSource[i];
        if ([sourceId isEqualToString:s.sourceId]) {
            /// 容错，没必要更新 由于可能会发生回滚操作，所以去掉容错
            //            if (progress <= form.progress) { return; }
            /// 更新一下状态
            s = [self _reviseDraftUploadStatus:s];
            /// 1. 获取进度
            s.progress = progress;
            /// 2. 刷新数据
            /// CoderMikeHe Fixed Bug: 细节处理，这里由于是每当成功提交一片数据，就会进来此处，这样会导致数据更新过于频繁，导致cell闪烁
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            /// 获取cell
            CMHFileUploadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                /// cell可见，则直接刷新View即可
                [cell refreshProgress:s animated:YES];
            }else{
                /// cell不可见，只更新数据即可，且无需刷新tableView
            }
            break;
        }
    }
}

/// 添加资源上传状态的通知
- (void)_fileUploadStatusDidChanged:(NSNotification *)note{
    NSString *sourceId = note.userInfo[CMHFileUploadSourceIdKey];
    NSInteger count = self.dataSource.count;
    for (NSInteger i = 0 ; i < count; i++) {
        CMHSource *s = self.dataSource[i];
        if ([sourceId isEqualToString:s.sourceId]) {
            /// 记录一下状态
            CMHFileUploadStatus currentStatus = s.uploadStatus;
            /// 更新一下状态
            s = [self _reviseDraftUploadStatus:s];
            /// 容错，没必要更新
            if (currentStatus == s.uploadStatus) { return; }
            /// 2. 刷新数据
            /// CoderMikeHe Fixed Bug: 细节处理，这里由于是每当成功提交一片数据，就会进来此处，这样会导致数据更新过于频繁，导致cell闪烁
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            /// 获取cell
            CMHFileUploadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                /// cell可见，则直接刷新View即可
                [cell refreshProgress:s animated:NO];
            }else{
                /// cell不可见，只更新数据即可，且无需刷新tableView
            }
            break;
        }
    }
}

/// 添加资源不可用上传状态的通知
- (void)_fileUploadDisableStatus:(NSNotification *)note{
    NSString *sourceId = note.userInfo[CMHFileUploadSourceIdKey];
    BOOL disable = [note.userInfo[CMHFileUploadDisableStatusKey] boolValue];
    NSInteger count = self.dataSource.count;
    for (NSInteger i = 0 ; i < count; i++) {
        CMHSource *s = self.dataSource[i];
        if ([sourceId isEqualToString:s.sourceId]) {
            /// 容错，没必要更新
            if (s.disable == disable) { return; }
            /// 1. 获取进度
            s.disable = disable;
            /// 2. 刷新数据
            /// CoderMikeHe Fixed Bug: 细节处理，这里由于是每当成功提交一片数据，就会进来此处，这样会导致数据更新过于频繁，导致cell闪烁
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            /// 获取cell
            CMHFileUploadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                /// cell可见，则直接刷新View即可
                [cell refreshProgress:s animated:NO];
            }else{
                /// cell不可见，只更新数据即可，且无需刷新tableView
            }
            break;
        }
    }
}

/// ---------- 辅助方法 ----------------
/// 额外配置一堆草稿数据 主要是根据 CMHFileUploadManager的uploadFileQueueDict字典里面的队列状态，来设置草稿页中资源的状态
- (NSArray *)_reviseDraftsUploadStatus:(NSArray *)drafts{
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:drafts.count];
    for (CMHSource * df in drafts) {
        [mutArray addObject:[self _reviseDraftUploadStatus:df]];
    }
    return mutArray.copy;
}
/// 更新一条数据
- (CMHSource *)_reviseDraftUploadStatus:(CMHSource *)draft{
    if (!draft.isManualSaveDraft) {
        /// 上传数据
        /// 草稿页只需要关心，是否在正在上传即可
        NSOperationQueue *queue = [[CMHFileUploadManager sharedManager].uploadFileQueueDict objectForKey:draft.sourceId];
        if (queue) {
            /// 有上传队列，查看
            draft.uploadStatus = queue.isSuspended?CMHFileUploadStatusWaiting:CMHFileUploadStatusUploading;
        }else{
            /// 无上传队列，就是暂停
            draft.uploadStatus = CMHFileUploadStatusWaiting;
        }
    }
    return draft;
}

#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 配置资源数据 一般这个方法会放在 程序启动后切换到主页时调用
    [[CMHFileUploadManager sharedManager] configure];
    
    
    @weakify(self);
    [MBProgressHUD mh_showProgressHUD:@"加载中..." addedToView:self.view];
    /// 获取草稿数据
    [self _fetchDraftDataFromDB];
    
    /// 添加资源保存草稿成功的通知
    [[MHNotificationCenter rac_addObserverForName:CMHSaveSourceToDBSuccessNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self _saveSourceToDBSuccess:x];
    }];
    
    /// 添加资源上传完毕的通知
    [[MHNotificationCenter rac_addObserverForName:CMHFileUploadDidFinishedNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self _fileUploadDidFinished:x];
    }];
    
    /// 添加资源进度的通知
    [[MHNotificationCenter rac_addObserverForName:CMHFileUploadProgressDidChangedNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self _fileUploadProgressDidChanged:x];
    }];
    
    /// 添加资源上传状态的通知
    [[MHNotificationCenter rac_addObserverForName:CMHFileUploadStatusDidChangedNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self _fileUploadStatusDidChanged:x];
    }];
    
    /// 添加资源不可用上传状态的通知
    [[MHNotificationCenter rac_addObserverForName:CMHFileUploadDisableStatusNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self _fileUploadDisableStatus:x];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHFileUploadCell cellWithTableView:tableView];
}

- (void)configureCell:(CMHFileUploadCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    cell.delegate = self;
    [cell configureModel:object];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT + 10, 0, 0, 0);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMHSource *source = self.dataSource[indexPath.row];
    /// 只有手动存储的资源才允许编辑
    if (source.isManualSaveDraft) {
        CMHCreateSourceController *createSource = [[CMHCreateSourceController alloc] initWithParams:@{CMHViewControllerUtilKey:source}];
        [self.navigationController pushViewController:createSource animated:YES];
        return;
    }
}

#pragma mark - CMHFileUploadCellDelegate
/// 上传or取消
- (void)fileUploadCell:(CMHFileUploadCell *)cell needUpload:(BOOL)needUpload{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CMHSource *draft = self.dataSource[indexPath.row];
    draft.uploadStatus = needUpload ? CMHFileUploadStatusUploading : CMHFileUploadStatusWaiting;
    
    if (needUpload) {
        /// 继续上传
        [[CMHFileUploadManager sharedManager] resumeUpload:draft.sourceId];
    }else{
        /// 暂停
        [[CMHFileUploadManager sharedManager] suspendUpload:draft.sourceId];
    }
    /// 刷新数据
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    
}

/// 删除
- (void)fileUploadCellDidClickedDeleteButton:(CMHFileUploadCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    @weakify(self);
    [NSObject mh_showAlertViewWithTitle:nil message:@"确定是否要删除此草稿？" confirmTitle:@"确定" cancelTitle:@"取消" confirmAction:^{
        @strongify(self);
        [self _deleteDraftFile:indexPath.row];
    } cancelAction:NULL];
    
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"草稿";
    self.tableView.rowHeight = 106.0f;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    /// 新增
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_createSource)];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter



@end
