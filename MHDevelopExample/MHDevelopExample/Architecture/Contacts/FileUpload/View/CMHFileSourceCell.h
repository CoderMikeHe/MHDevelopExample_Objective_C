//
//  CMHFileSourceCell.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  资源(图片、视频)文件Cell

#import "CMHTableViewCell.h"

@class CMHFileSourceCell;

typedef NS_ENUM(NSUInteger, CMHTapFileViewType) {
    CMHTapFileViewTypeDelete = 0,  /// 删除
    CMHTapFileViewTypeAdd,         /// 添加
    CMHTapFileViewTypePreview,     /// 预览
};

@protocol CMHFileSourceCellDelegate <NSObject>
@optional
- (void)fileSourceCell:(CMHFileSourceCell *)cell tapIndex:(NSInteger)index tapType:(CMHTapFileViewType)type;

@end



@interface CMHFileSourceCell : CMHTableViewCell<CMHConfigureView>

/// delegate
@property (nonatomic , readwrite , weak) id <CMHFileSourceCellDelegate> delegate;

/// 获取cell的高度
+ (CGFloat)fetchCellHeightForSources:(NSArray *)sources;

@end
