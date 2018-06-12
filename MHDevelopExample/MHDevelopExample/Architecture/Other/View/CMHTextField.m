//
//  CMHTextField.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHTextField.h"

@implementation CMHTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tintColor = CMH_MAIN_TINTCOLOR;
    self.placeholderColor = MHColorFromHexString(@"#AEBACD");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = CMH_MAIN_TINTCOLOR;
        self.placeholderColor = MHColorFromHexString(@"#AEBACD");
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    [self setPlaceholderColor:self.placeholderColor];
}

@end
