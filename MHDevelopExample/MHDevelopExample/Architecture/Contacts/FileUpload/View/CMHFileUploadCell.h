//
//  CMHFileUploadCell.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/17.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHTableViewCell.h"
@class CMHFileUploadCell,CMHSource;
@protocol CMHFileUploadCellDelegate <NSObject>
@optional
/// 点击上传按钮
- (void)fileUploadCell:(CMHFileUploadCell *)cell needUpload:(BOOL)needUpload;
/// 点击删除按钮
- (void)fileUploadCellDidClickedDeleteButton:(CMHFileUploadCell *)cell;
@end

@interface CMHFileUploadCell : CMHTableViewCell<CMHConfigureView>

/// delegate
@property (nonatomic , readwrite , weak) id <CMHFileUploadCellDelegate> delegate ;


/// 更新进度 这个方法主要是解决因为进度的更新会比较频繁，导致Cell闪烁的Bug
/// source -- 资源
/// animated -- 动画
- (void)refreshProgress:(CMHSource *)source animated:(BOOL)animated;

@end
