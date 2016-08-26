//
//  QRTabBar.m
//  QRcode
//
//  Created by hzf on 16/8/17.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "QRTabBar.h"

@implementation QRTabBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 60;
    return sizeThatFits;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
