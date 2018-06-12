//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCard.h"
#import "XLCardItem.h"

@interface XLCard () {
    UIImageView *_imageView;
    UILabel *_textLabel;
}
@end

@implementation XLCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelHeight = self.bounds.size.height * 0.20f;
    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewHeight, self.bounds.size.width, labelHeight)];
    _textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _textLabel.font = [UIFont systemFontOfSize:22];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
}

-(void)setItem:(XLCardItem *)item {
    _imageView.image = [UIImage imageNamed:item.imageName];
    _textLabel.text = item.title;
}

@end
