//
//  FEMainTabBarController.m
//  QRcode
//
//  Created by hzf on 16/8/17.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FEMainTabBarController.h"
#import "FEQRCatcherViewController.h"
#import "FEHistoryViewController.h"
#import "QRTabBar.h"

@interface FEMainTabBarController ()

@end

@implementation FEMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FEQRCatcherViewController *QRCatcherViewController = [[FEQRCatcherViewController alloc]init];
    QRCatcherViewController.tabBarItem = [self setTabBarItemWithTitle:@"扫描" imageStr:@"scan_white" selectedImageStr:@"scan_blue"];
    
    UINavigationController *QRCatcherNav = [[UINavigationController alloc]initWithRootViewController:QRCatcherViewController];
    
    FEHistoryViewController *historyViewController = [[FEHistoryViewController alloc]init];
    historyViewController.tabBarItem = [self setTabBarItemWithTitle:@"历史记录" imageStr:@"history" selectedImageStr:@"history_blue"];
    UINavigationController *historyNav = [[UINavigationController alloc]initWithRootViewController:historyViewController];
    
    self.viewControllers = @[QRCatcherNav, historyNav];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITabBarItem *)setTabBarItemWithTitle:(NSString *)title imageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr {
    //    UIImage *image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  //原图效果不好
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.title = title;
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x30739e)} forState:UIControlStateSelected];
    //    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbfbfbf)} forState:UIControlStateNormal]; //文字颜色不清晰
    tabBarItem.image = image;
    tabBarItem.selectedImage = selectedImage;
    return tabBarItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
