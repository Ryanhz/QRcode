//
//  FETextViewController.m
//  QRcode
//
//  Created by hzf on 16/8/19.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FETextViewController.h"

@interface FETextViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *linkBtn;
@property (nonatomic, weak) Entity *data;
@property (nonatomic) BOOL isEdit;

@end

@implementation FETextViewController

- (instancetype)initWithEntity:(Entity *)entity {
    self = [super init];
    if (self) {
        _data = entity;
        _isEdit = YES;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isEdit = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//     DLog(@"")
    //3
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_NavTitle) {
       self.navigationItem.title = _NavTitle;
    }
    
    if (_isEdit) {
        [self setEditNavBarItem];
    } else {
        [self setSaveNaVBarItem];
    }
    
   //2
}

- (void)viewDidLoad {
    //1
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(0xEEF3F6);
    self.navigationItem.title = @"扫描的信息";
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------------------------action

- (void)openURL:(UIButton *)sender {
    [self openURLStr:_text];
}

- (void)saveData:(UIBarButtonItem *)sender {
    [self showAlert:_text];
}

- (void)editData:(UIBarButtonItem *)sender {
    [self showAlert:nil];
}


#pragma mark-------------------------<#(^ 0 - o - 0^)#>

- (void)setLinkBtnTitle:(BOOL)flag {
    
    if (flag) {
        NSAttributedString *NormalTitle = [[NSAttributedString alloc]initWithString:_text attributes:@{
                                                                                              NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                              NSForegroundColorAttributeName : [UIColor blueColor]
                                                                                              }];
        NSAttributedString *selectTitle = [[NSAttributedString alloc]initWithString:_text attributes:@{
                                                                                               NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                               NSForegroundColorAttributeName : [UIColor grayColor]
                                                                                               }];
        [self.linkBtn setAttributedTitle:NormalTitle forState:UIControlStateNormal];
        [self.linkBtn setAttributedTitle:selectTitle forState:UIControlStateHighlighted];
        [self.view addSubview:self.linkBtn];
        FEWeakSelf(weakSelf)
        [_linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(64);
            make.left.equalTo(weakSelf.view).offset(20);
            make.height.mas_greaterThanOrEqualTo(@44);
            make.right.equalTo(weakSelf.view).offset(-44);
        }];
    } else {
         [self.view addSubview:self.textView];
        _textView.text = _text;
       
    }
}

- (void)openURLStr:(NSString *)str {
    [[UIApplication sharedApplication] openURL:[NSString HTTPURLFromString:str]];
}

- (void)showAlert:(NSString *)str {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑" message:@"更改信息" preferredStyle:UIAlertControllerStyleAlert];
    
    
    FEWeakSelf(weakSelf)
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
        textField.text = weakSelf.data.name;
        textField.tag = 10000;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 10001;
        
        if (_isEdit) {
            textField.text = weakSelf.data.data;
        } else {
            textField.text = str;
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = alertController.textFields;
        UITextField *nameTF = array[0];
//        DLog(@"%@", nameTF.text);
        UITextField *textTF = array[1];
//        DLog(@"%@",textTF.text);
        
        if (_isEdit) {
            dispatch_after(0.2, dispatch_get_main_queue(), ^{
                [weakSelf editData:nameTF.text text:textTF.text];
            });
        } else {
            dispatch_after(0.2, dispatch_get_main_queue(), ^{
                [weakSelf insertData:nameTF.text text:textTF.text];
            });
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

//修改
- (void)editData:(NSString *)name text:(NSString *)str {
    FECoreDataHelper *helper = [FECoreDataHelper shareHelper];
    _data.name = name;
    _data.data = str;
    
    NSError *error = nil;
    if ([helper.managedObjectContext hasChanges]) {
        [helper.managedObjectContext save:&error];
    }
    
    if (error) {
        [self.view makeToast:@"修改失败" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    [self setText:str];
    [self.view makeToast:@"修改成功" duration:2 position:CSToastPositionCenter];
}

//保存
- (void)insertData:(NSString *)name text:(NSString *)str {
    FECoreDataHelper *helper = [FECoreDataHelper shareHelper];
    Entity *data = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:helper.managedObjectContext];
    data.name = name;
    data.data = str;
    data.date = [NSDate date];
    
    NSError *error = nil;
    
    if (helper.managedObjectContext.hasChanges) {
        [helper.managedObjectContext save:&error];
    }
    
    if (error) {
        DLog(@"saveerror: %@",error);
        [self.view makeToast:@"保存失败" duration:2 position:CSToastPositionCenter];
        return ;
    }
    
    [self.view makeToast:@"保存成功" duration:2 position:CSToastPositionCenter];
}

#pragma mark-------------------------setter, getter

- (void)setSaveNaVBarItem {
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData:)];
    
    self.navigationItem.rightBarButtonItem = save;
}

- (void)setEditNavBarItem {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editData:)];
    
    self.navigationItem.rightBarButtonItem = edit;
}



- (void)setText:(NSString *)text {
    if (!text) {
        _text = @"";
        return;
    }
    
    _text = text;
    if ([_text isURL]) {
        [self setLinkBtnTitle:YES];
    } else {
        [self setLinkBtnTitle:NO];
    }
}


- (void)setNavTitle:(NSString *)NavTitle {
    _NavTitle = NavTitle;
}

- (UIButton *)linkBtn {
    if (!_linkBtn) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _linkBtn.titleLabel.numberOfLines = 0;
        _linkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_linkBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_linkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_linkBtn addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkBtn;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textColor = [UIColor blackColor];
        _textView.editable = NO;
    }
    return _textView;
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
