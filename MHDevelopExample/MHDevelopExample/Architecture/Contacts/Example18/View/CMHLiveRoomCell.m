//
//  CMHLiveRoomCell.m
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "CMHLiveRoomCell.h"
#import "CMHLiveRoom.h"
@interface CMHLiveRoomCell ()
/// viewModel
@property (nonatomic, readwrite, strong) CMHLiveRoom *liveRoom;

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
/// nickenameLabel
@property (weak, nonatomic) IBOutlet UILabel *nickenameLabel;
/// locationBtn
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/// starLevelView
@property (weak, nonatomic) IBOutlet UIImageView *starLevelView;
/// audienceNumsLabel
@property (weak, nonatomic) IBOutlet UILabel *audienceNumsLabel;
/// coverView
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
/// headTipsBtn
@property (weak, nonatomic) IBOutlet UIButton *headTipsBtn;
/// signView
@property (weak, nonatomic) IBOutlet UIImageView *signView;

@end

@implementation CMHLiveRoomCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LiveRoomCell";
    CMHLiveRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)configureModel:(CMHLiveRoom *)liveRoom{
    self.liveRoom = liveRoom;
    
    [self.avatarView yy_setImageWithURL:liveRoom.smallpic placeholder:MHImageNamed(@"header_default_100x100") options:CMHWebImageOptionAutomatic completion:NULL];
    self.signView.hidden = !liveRoom.isSign;
    
    self.nickenameLabel.text = liveRoom.myname;
    self.starLevelView.image = MHImageNamed(liveRoom.girlStar);
    
    [self.locationBtn setTitle:liveRoom.gps forState:UIControlStateNormal];
    self.audienceNumsLabel.attributedText =liveRoom.allNumAttr;
    
    [self.headTipsBtn setTitle:liveRoom.familyName forState:UIControlStateNormal];
    [self.coverView yy_setImageWithURL:liveRoom.bigpic placeholder:MHImageNamed(@"placeholder_head_100x100") options:CMHWebImageOptionAutomatic completion:NULL];
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
