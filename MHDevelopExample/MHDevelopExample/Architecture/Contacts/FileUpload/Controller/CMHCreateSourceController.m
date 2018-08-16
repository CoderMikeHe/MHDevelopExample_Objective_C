//
//  CMHCreateSourceController.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

/// S
#import <Photos/Photos.h>

/// C
#import "CMHCreateSourceController.h"
#import "CMHEditTitleController.h"
#import <TZImagePickerController/TZImagePickerController.h>
/// V
#import "CMHCoverSourceView.h"
#import "CMHFileSourceCell.h"
/// M
#import "CMHSource.h"
/// T


@interface CMHCreateSourceController ()<CMHFileSourceCellDelegate,TZImagePickerControllerDelegate>

/// 是否是编辑资源
@property (nonatomic , readwrite , assign , getter = isEditSource) BOOL editSource;
/// 资源模型
@property (nonatomic , readwrite , strong) CMHSource *source;
/// 选中的Assets
@property (nonatomic , readwrite , strong) NSMutableArray *selectedAssets;
/// 选中的photos
@property (nonatomic , readwrite , strong) NSMutableArray *selectedPhotos;
/// 允许选中的最大文件数
@property (nonatomic , readwrite , assign) NSInteger maxFileCount;
@end

@implementation CMHCreateSourceController
{
    /// 串行处理资源的的队列
    dispatch_queue_t _compressQueue;
}
- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [super initWithParams:params]) {
        /// 获取数据
        CMHSource *source = params[CMHViewControllerUtilKey];
        self.source = [[CMHSource alloc] init];
        if (MHObjectIsNil(source)) { /// 新建资源
            self.editSource = NO;
        }else{ /// 编辑资源
            /// CoderMikeHe Fixed Bug :这里务必要将资源进行拷贝。
            [self.source mergeValuesForKeysFromModel:source];
            self.editSource = YES;
        }
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

#pragma mark - 事件处理Or辅助方法
/// 保存草稿
- (void)_saveDraftSource{
    /// 手动存储草稿
    self.source.manualSaveDraft = YES;
    /// showHUD
    [MBProgressHUD mh_showProgressHUD:@"正在保存草稿" addedToView:self.view];
    /// save
    @weakify(self);
    [self.source saveSourceToDB:^(BOOL isSuccess) {
        @strongify(self);
        [MBProgressHUD mh_hideHUDForView:self.view];
        [MBProgressHUD mh_showTips:isSuccess?@"保存草稿成功":@"保存草稿失败"];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/// 提交资源
- (void)_commitSource{
    /// 检查资源必填项
    if (!MHStringIsNotEmpty(self.source.title)) {
        [MBProgressHUD mh_showTips:@"请输入标题..." addedToView:self.view];
        return;
    }
    if (MHArrayIsEmpty(self.source.files)) {
        [MBProgressHUD mh_showTips:@"请选择要上传的资源..." addedToView:self.view];
        return;
    }
    /// showHUD
    [MBProgressHUD mh_showProgressHUD:@"正在上传资源..." addedToView:self.view];
    
    /// 提交资源
    @weakify(self);
    [self.source commitSource:^(BOOL isSuccess) {
        @strongify(self);
        /// hide hud
        [MBProgressHUD mh_hideHUDForView:self.view];
        if (!isSuccess) { return ; }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



/// 添加图片
- (void)_addPhotos{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxFileCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = self.source.isSelectOriginalPhoto;
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 300; // 视频最大拍摄时间 5min
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    }];
    /// CoderMikeHe Fixed Bug : 这里新建模块只需要展示，小图，所以导出图片不需要太大，而且导出的图片需要存入数据库，所以尽量尺寸适量即可，否则会导致存储数据库和读取数据库异常的慢
    imagePickerVc.photoWidth = ceil(MH_SCREEN_WIDTH / 4);
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    /// 上传原图，无压缩
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = YES; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // statusBar的样式，默认为UIStatusBarStyleLightContent
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/// 预览图片
- (void)_previewPhotosWithIndex:(NSInteger)index{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:index];
    imagePickerVc.maxImagesCount = self.maxFileCount;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingMultipleVideo = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    imagePickerVc.isSelectOriginalPhoto = self.source.isSelectOriginalPhoto;
    /// CoderMikeHe Fixed Bug : 设置代理没有啥子用 Why ???
//    imagePickerVc.pickerDelegate = self;
    /// CoderMikeHe Fixed Bug : didFinishPickingPhotosWithInfosHandle 也不回调， why ??
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        [self _finishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:nil];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/// 删除图片
- (void)_deletePhotoWithIndex:(NSInteger)index{
    /// 删除某张图片
    NSMutableArray *files = [NSMutableArray arrayWithArray:self.source.files];
    CMHFile *file = files[index];
    /// 删除资源
    [files removeObject:file];
    
    if (file.disablePreview) {
        /// 不支持预览,增加选中相册的最大数
        self.maxFileCount+=1;
    }else{
        /// 支持预览
        [self.selectedAssets removeObjectAtIndex:index];
        [self.selectedPhotos removeObjectAtIndex:index];
    }
    self.source.files = files.copy;
    /// 刷新表格
    [self reloadData];
}

/// 完成图片选中
- (void)_finishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    /// 选中的相片以及Asset
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    /// 记录一下是否上传原图
    self.source.selectOriginalPhoto = isSelectOriginalPhoto;
    
    /// 生成资源文件
    __block NSMutableArray *files = [NSMutableArray array];
    /// 记录之前的源文件
    NSMutableArray *srcFiles = [NSMutableArray arrayWithArray:self.source.files];
    
    NSInteger count = MIN(photos.count, assets.count);
    /// 处理资源
    /// CoderMikeHe Fixed Bug : 这里可能会涉及到选中多个视频的情况，且需要压缩视频的情况
    [MBProgressHUD mh_showProgressHUD:@"正在处理资源..." addedToView:self.view];
    
    NSLog(@"Compress Source Complete Before %@ !!!!" , [NSDate date]);
    
    /// 获取队列组
    dispatch_group_t group = dispatch_group_create();
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    for (NSInteger i = 0; i < count; i ++ ) {
        dispatch_group_enter(group);
        dispatch_async(_compressQueue, ^{ // 异步追加任务
            /// 设置文件类型
            PHAsset *asset = assets[i];
            /// 图片或资源 唯一id
            NSString *localIdentifier = [[TZImageManager manager] getAssetIdentifier:asset];
            UIImage *thumbImage = photos[i];
            
            /// 这里要去遍历已经获取已经存在资源的文件 内存中
            BOOL isExistMemory = NO;
            for (CMHFile *f in srcFiles.reverseObjectEnumerator) {
                /// 判断是否已经存在路径和文件
                if ([f.localIdentifier isEqualToString:localIdentifier] && MHStringIsNotEmpty(f.filePath)) {
                    [files addObject:f];
                    [srcFiles removeObject:f];
                    isExistMemory = YES;
                    break;
                }
            }
            if (isExistMemory) {
                NSLog(@"++++ 💕文件已经存在内存中💕 ++++");
                dispatch_group_leave(group);
            }else{
                //// 视频和图片，需要缓存，这样会明显减缓，应用的内存压力
                /// 是否已经缓存在沙盒
                BOOL isExistCache = NO;
                
                /// 1. 先去缓存里面去取
                NSString *filePath = (NSString *)[[YYCache sharedCache] objectForKey:localIdentifier];
                /// 这里必须的判断一下filePath是否为空! 以免拼接起来出现问题
                if (MHStringIsNotEmpty(filePath)) {
                    /// 2. 该路径的本地资源是否存在， 拼接绝对路径，filePath是相对路径
                    NSString * absolutePath = [[CMHFileManager cachesDir] stringByAppendingPathComponent:filePath];
                    if ([CMHFileManager isExistsAtPath:absolutePath]) {
                        /// 3. 文件存在沙盒中，不需要获取了
                        isExistCache = YES;
                        
                        /// 创建文件模型
                        CMHFile *file = [[CMHFile alloc] init];
                        file.thumbImage = thumbImage;
                        file.localIdentifier = localIdentifier;
                        /// 设置文件类型
                        file.fileType = (asset.mediaType == PHAssetMediaTypeVideo)? CMHFileTypeVideo : CMHFileTypePicture;
                        file.filePath = filePath;
                        [files addObject:file];
                    }
                }
                
                
                if (isExistCache) {
                    NSLog(@"++++ 💕文件已经存在磁盘中💕 ++++");
                    dispatch_group_leave(group);
                }else{
                    
                    /// 重新获取
                    if (asset.mediaType == PHAssetMediaTypeVideo) {  /// 视频
                        /// 获取视频文件
                        [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
                            NSLog(@"+++ 视频导出到本地完成,沙盒路径为:%@ %@",outputPath,[NSThread currentThread]);
                            /// Export completed, send video here, send by outputPath or NSData
                            /// 导出完成，在这里写上传代码，通过路径或者通过NSData上传
                            /// CoderMikeHe Fixed Bug :如果这样写[NSData dataWithContentsOfURL:xxxx]; 文件过大，会导致内存吃紧而闪退
                            /// 解决办法，直接移动文件到指定目录《类似剪切》
                            NSString *relativePath = [CMHFile moveVideoFileAtPath:outputPath];
                            if (MHStringIsNotEmpty(relativePath)) {
                                CMHFile *file = [[CMHFile alloc] init];
                                file.thumbImage = thumbImage;
                                file.localIdentifier = localIdentifier;
                                /// 设置文件类型
                                file.fileType =  CMHFileTypeVideo;
                                file.filePath = relativePath;
                                [files addObject:file];
                                
                                /// 缓存路径
                                [[YYCache sharedCache] setObject:file.filePath forKey:localIdentifier];
                            }
                            
                            dispatch_group_leave(group);
                            /// 信号量+1 向下运行
                            dispatch_semaphore_signal(semaphore);
                            
                        } failure:^(NSString *errorMessage, NSError *error) {
                            NSLog(@"😭😭😭++++ Video Export ErrorMessage ++++😭😭😭 is %@" , errorMessage);
                            dispatch_group_leave(group);
                            /// 信号量+1 向下运行
                            dispatch_semaphore_signal(semaphore);
                        }];
                    }else{  /// 图片
                        [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                            NSString* relativePath = [CMHFile writePictureFileToDisk:data];
                            if (MHStringIsNotEmpty(relativePath)) {
                                CMHFile *file = [[CMHFile alloc] init];
                                file.thumbImage = thumbImage;
                                file.localIdentifier = localIdentifier;
                                /// 设置文件类型
                                file.fileType =  CMHFileTypePicture;
                                file.filePath = relativePath;
                                [files addObject:file];
                                
                                /// 缓存路径
                                [[YYCache sharedCache] setObject:file.filePath forKey:localIdentifier];
                            }
                            dispatch_group_leave(group);
                            /// 信号量+1 向下运行
                            dispatch_semaphore_signal(semaphore);
                        }];
                    }
                    /// 等待
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                }
            }
        });
    }
    
    /// 所有任务完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"Compress Source Complete After %@ !!!!" , [NSDate date]);
        ///
        [MBProgressHUD mh_hideHUDForView:self.view];
        /// 这里是所有任务完成
        self.source.files = files.copy;
        [self.tableView reloadData];
    });
}


/// 计算资源大小
- (void)_calulateFileSize:(NSData *)data {
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"Data Length Is  👉【 %.3f 】【 %@ 】",dataLength,typeArray[index]);
}



#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 默认是五十个资源
    self.maxFileCount = CMHFileMaxCount;
    /// 这里需要容错处理
    if (self.isEditSource) { /// 编辑资源
        NSMutableArray *selectedAssets = [NSMutableArray array];
        NSMutableArray *selectedPhotos = [NSMutableArray array];
        for (CMHFile * file in self.source.files) {
            /// 获取PHAsset
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[file.localIdentifier] options:nil];
            PHAsset *asset = fetchResult.firstObject;
            if (!asset) {
                // 如果找不到照片就进入这个if，可能是用户从相册里面删除了
                file.disablePreview = YES;    /// 不支持预览
                /// 一旦有一个不支持预览，则选中数减一
                self.maxFileCount -= 1;
            }else{
                [selectedAssets addObject:asset];
                [selectedPhotos addObject:file.thumbImage];
            }
        }
        self.selectedAssets = selectedAssets;
        self.selectedPhotos = selectedPhotos;
    }
    [self.dataSource addObject:self.source];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHFileSourceCell cellWithTableView:tableView];
}

- (void)configureCell:(CMHFileSourceCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    cell.delegate = self;
    [cell configureModel:object];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMHSource *source = self.dataSource[indexPath.row];
    return [CMHFileSourceCell fetchCellHeightForSources:source.files];
}

#pragma mark - CMHFileSourceCellDelegate
- (void)fileSourceCell:(CMHFileSourceCell *)cell tapIndex:(NSInteger)index tapType:(CMHTapFileViewType)type{
    if (type == CMHTapFileViewTypeAdd) {          /// 添加
        [self _addPhotos];
    }else if (type == CMHTapFileViewTypePreview){ /// 预览
        [self _previewPhotosWithIndex:index];
    }else if (type == CMHTapFileViewTypeDelete){  /// 删除
        [self _deletePhotoWithIndex:index];
    }
}

#pragma mark - TZImagePickerControllerDelegate
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    /// 完成图片上传
    [self _finishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:infos];
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"新建";
    /// 创建串行队列
    _compressQueue = dispatch_queue_create("ios.compress.queue", NULL);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
    UIBarButtonItem *draftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(_saveDraftSource)];
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_commitSource)];
    self.navigationItem.rightBarButtonItems = @[commitItem , draftItem];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 表头
    CMHCoverSourceView *tableHeaderView = [[CMHCoverSourceView alloc] init];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.tableHeaderView.mh_height = (MH_SCREEN_WIDTH * 9)/16.0f;
    [tableHeaderView configureModel:self.source];
    
    /// 回调
    @weakify(self);
    tableHeaderView.titleCallback = ^(CMHCoverSourceView *cs) {
        @strongify(self);
        CMHEditTitleController *editTitle = [[CMHEditTitleController alloc] initWithParams:@{CMHViewControllerIDKey : self.source}];
        [self.navigationController pushViewController:editTitle animated:YES];
    };
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
