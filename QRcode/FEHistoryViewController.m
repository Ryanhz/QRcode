//
//  FEHistoryViewController.m
//  QRcode
//
//  Created by hzf on 16/8/17.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FEHistoryViewController.h"
#import "FECoreDataHelper.h"
#import "Entity+CoreDataProperties.h"
#import "FETextViewController.h"

static NSString *kcellId = @"cellID";

@interface FEHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<Entity *> *dataArray;

@end

@implementation FEHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描记录";
    self.view.backgroundColor = UIColorFromRGB(0xEEF3F6);
}


- (void)initData{
    FECoreDataHelper *helper = [FECoreDataHelper shareHelper];
    FEWeakSelf(weakSelf)
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];

    NSError *error = nil;
    NSArray *array = [helper.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        [self.view makeToast:@"数据获取失败" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (array) {
        DLog(@"______%@",array);
        weakSelf.dataArray = array;
         [self.tableView reloadData];
    }
}

- (void)deleteData:(Entity *)data {
    FECoreDataHelper *helper = [FECoreDataHelper shareHelper];
    [helper.managedObjectContext deleteObject:data];
    
    NSError *error = nil;
    if ([helper.managedObjectContext hasChanges]) {
        [helper.managedObjectContext save:&error];
    }
    
    if (error) {
        DLog(@"error%@",error);
        [self.view makeToast:@"删除失败" duration:1 position:CSToastPositionCenter];
    }
}

- (void)openURLStr:(NSString *)str {
    [[UIApplication sharedApplication] openURL:[NSString HTTPURLFromString:str]];
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Entity *data = _dataArray[indexPath.row];
        
        [self deleteData:data];
        [self initData];;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellId forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kcellId];
    }
    
    
    NSString *name = _dataArray[indexPath.row].name;
    NSString *data = _dataArray[indexPath.row].data;
    cell.textLabel.text = name;
  
    cell.detailTextLabel.text = data;
   
    DLog(@"%@",data);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *data = _dataArray[indexPath.row].data;
    
    if ([data isURL]) {
        [self openURLStr:data];
        return;
    }
    
    FETextViewController *textVC = [[FETextViewController alloc]initWithEntity:_dataArray[indexPath.row]];
    textVC.hidesBottomBarWhenPushed = YES;
    textVC.text = data;
    [self.navigationController pushViewController:textVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT -64 -60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kcellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
