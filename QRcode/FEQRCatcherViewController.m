//
//  FEQRCatcherViewController.m
//  QRcode
//
//  Created by hzf on 16/8/17.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FEQRCatcherViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Tools.h"
#import "Entity+CoreDataProperties.h"
#import "FETextViewController.h"

#define koutput_Width 200
#define koutput_height 200

@interface FEQRCatcherViewController ()<AVCaptureMetadataOutputObjectsDelegate>


//预览图层
@property (nonatomic, strong) UIView *coverView;

//摄像头设备
@property (nonatomic, strong) AVCaptureDevice *device;

//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出流
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

//session
@property (nonatomic, strong) AVCaptureSession *session;

//
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewer;

//蒙版图层
@property (nonatomic, strong) CALayer * coverLayer;


//刷新线
@property (nonatomic, strong) UIImageView * lineIV;

@property (nonatomic) CGRect outputRect;

@end

@implementation FEQRCatcherViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScan];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScan];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫一扫";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(0xEEF3F6);
    _outputRect = CGRectMake((KSCREEN_WIDTH - koutput_Width)/2, (KSCREEN_HEIGHT -  60 - 64 - koutput_height) /2, koutput_Width, koutput_height);
    [self setCoverViews];
    [self setupAVFoundation];

}


- (void)setupAVFoundation{
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
     //session
    self.session = [[AVCaptureSession alloc] init];
    //输出的质量s
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset3840x2160]) {
         [self.session setSessionPreset:AVCaptureSessionPreset3840x2160];
    } else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    } else if([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    } else if([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
    } else if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
   
    
    NSError * error = nil;
    //iput
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (error) {
        DLog(@"输入流创建错误 ：%@",error);
        return ;
    }
    // 输出流
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:_output]) {
        [self.session addOutput:_output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeQRCode
                                        ];
    
    //preview
    self.previewer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    self.previewer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewer.frame = CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64 -60);
    self.previewer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4].CGColor;
    [self.view.layer insertSublayer:self.previewer atIndex:0];
}

- (void)setCoverViews {
    
    self.coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_coverView];
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 60 -64)];
    
    UIBezierPath *rePath =[UIBezierPath bezierPathWithRoundedRect:CGRectMake((KSCREEN_WIDTH - koutput_Width)/2, 64 + (KSCREEN_HEIGHT -  60 - 64 - koutput_height) /2, koutput_Width, koutput_height) cornerRadius:0];
    
    [path appendPath:[rePath bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    maskLayer.path = path.CGPath;
    self.coverView.layer.mask = maskLayer;

}

- (void)showAnimation {
    if (!self.lineIV) {
        self.lineIV = [[UIImageView alloc]initWithFrame:CGRectMake((KSCREEN_WIDTH - koutput_Width) /2,  64 + (KSCREEN_HEIGHT -  60 - 64 - koutput_height) /2, koutput_height, 2)];
        self.lineIV.backgroundColor = [UIColor blueColor];
        [self.view addSubview:self.lineIV];
    }
    
    
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.fromValue = [NSValue valueWithCGPoint:CGPointMake(KSCREEN_WIDTH/2, 64 + (KSCREEN_HEIGHT -  60 - 64 - koutput_height) /2)];
    
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(KSCREEN_WIDTH/2, 64 + (KSCREEN_HEIGHT -  60 - 64 - koutput_height) /2 + koutput_height)];
    animate.duration = 3.0;
    animate.repeatCount = HUGE_VALF;
    [self.lineIV.layer addAnimation:animate forKey:nil];
    
}
    

- (void)stopScan {
    [self.session stopRunning];
    if (self.lineIV) {
        [self.lineIV.layer removeAllAnimations];
    }
}

- (void)startScan {
    [self.session startRunning];
    
    //把一个在previewlayer坐标系中的rect 转换成 一个在metadataoutputs坐标系中的rect
    //outputRect 应该是相对与previewlayer的
    CGRect rect = [_previewer metadataOutputRectOfInterestForRect:_outputRect];
    self.output.rectOfInterest = rect;
    CGRect rect2 = [_previewer rectForMetadataOutputRectOfInterest:rect];
    DLog(@"rect2:%@", NSStringFromCGRect(rect2));
    DLog("%@",NSStringFromCGRect(_outputRect));
    [self showAnimation];
}



#pragma mark-------------------------AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(metadataObjects.count >0){
        
        [self stopScan];
    }
    
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
        
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            DLog(@"%@",metadata.stringValue);
        }
        
        [self showDetail:metadata.stringValue];
    }
  
}

- (void)showDetail:(NSString *)str {
    FETextViewController *textVC = [[FETextViewController alloc]init];
    textVC.hidesBottomBarWhenPushed = YES;
    textVC.text = str;
    [self.navigationController pushViewController:textVC animated:YES];
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
