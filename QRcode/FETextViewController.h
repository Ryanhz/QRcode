//
//  FETextViewController.h
//  QRcode
//
//  Created by hzf on 16/8/19.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FETextViewController : UIViewController

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *NavTitle;

- (instancetype)initWithEntity:(Entity *)entity;

@end
