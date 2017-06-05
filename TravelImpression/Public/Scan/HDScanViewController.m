//
//  HDScanViewController.h
//
//  Created by SimonMBP on 14-8-21.
//  Copyright (c) 2014年 Simon All rights reserved.
//
#import "HDScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kDevideRatio   DEVICE_WIDTH / 375
#define kXHQRCodeRectPaddingX 30 * kDevideRatio

@interface HDScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureVideoPreviewLayer * previewLayer;
}
@end

@implementation HDScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = nil;
    [self setTitle:@"扫一扫"];
    self.view.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                     object:nil
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification * _Nonnull note) {
                                                     if (weakSelf){
                                                         //调整扫描区域
                                                         AVCaptureMetadataOutput *output = session.outputs.firstObject;
                                                         output.rectOfInterest = [previewLayer metadataOutputRectOfInterestForRect:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
                                                     }
                                                 }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
    
    [self setupSubview];
    if (_isJoinCarTeam) {
        _enterWordView = [[EnterPassWordView alloc] initWithFrame:rectMake];
        _enterWordView.carID = _carID;
        [self.view addSubview:_enterWordView];
        _enterWordView.hidden = YES;
        [self setInitView];
        [self setNormalOrHighlight:1];
    }
}

- (void)setInitView
{
    NSArray *normalArr = @[@"koulinghui", @"saomahui"];
    NSArray *highArr = @[@"koulinghuang", @"saomahuang"];
    NSArray *titleArr = @[@"口令", @"扫码"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH  - kXHQRCodeRectPaddingX - 32 - (32 + 20) * i, 40, 32, 32)];
        btn.tag = 666 + i;
        [btn setImage:[UIImage imageNamed:normalArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highArr[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH  - kXHQRCodeRectPaddingX - 32 - (32 + 20) * i, 75, 32, 20)];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(14);
        label.tag = 999 + i;
        label.textColor = [UIColor grayColor];
        [self.view addSubview:label];
    }
    
}

- (void)setNormalOrHighlight:(NSInteger)index
{
    UILabel *label0 = (UILabel *)[self.view viewWithTag:999];
    UILabel *label1 = (UILabel *)[self.view viewWithTag:1000];
    UIButton *btn0 = (UIButton *)[self.view viewWithTag:666];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:667];
    
    label0.textColor = index ? [UIColor grayColor] : [UIColor lightGrayColor];
    label1.textColor = index ? [UIColor lightGrayColor] : [UIColor grayColor];
    btn0.selected = index ? NO : YES;
    btn1.selected = index ? YES : NO;
}

- (void)switchAction:(UIButton *)btn
{
    if (btn.tag == 666) {
        //点击口令
        [self setNormalOrHighlight:0];
        _sanningView.hidden = YES;
        _enterWordView.hidden = NO;
    } else {
        //点击扫码
        [self setNormalOrHighlight:1];
        _sanningView.hidden = NO;
        [self.view endEditing:YES];
        _enterWordView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [session stopRunning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationWillEnterForeground:(id)sender
{
    [_sanningView startScanning];
}

#pragma mark - 创建界面
-(void)setupSubview{
    
    rectMake = CGRectMake(0.f, 0.f, DEVICE_WIDTH, DEVICE_HEIGHT);
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if(input) {
        [session addInput:input];
    } else {
        //出错处理
        NSString *msg = [NSString stringWithFormat:@"请在手机【设置】-【隐私】-【相机】选项中，允许【%@】访问您的相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [av show];
        return;
    }
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    NSLog(@"%@",NSStringFromCGRect(previewLayer.frame));
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    previewLayer.frame = rectMake;
//    output.rectOfInterest = CGRectMake(120.f/DEVICE_HEIGHT, 55.f/DEVICE_WIDTH, (DEVICE_WIDTH-110.f)/DEVICE_WIDTH, (DEVICE_WIDTH-110.f)/DEVICE_HEIGHT);
    _sanningView = [[HDScanningView alloc] initWithFrame:rectMake];
    [self.view.layer addSublayer:_sanningView.layer];
    
    //开始捕获
    [session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (metadataObjects.count>0) {
            [session stopRunning];
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
            //输出扫描字符串
            if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                NSString * num = metadataObject.stringValue;
                NSLog(@"%@",metadataObject.stringValue);
                if (_isJoinCarTeam) {
                    if (_smsFinishBlock) {
                        if (!_sanningView.hidden) {
                            _smsFinishBlock(num);
                        }
                    }
                } else {
                    NSLog(@"%@",metadataObject.stringValue);
                    if (_smsFinishBlock) {
                        _smsFinishBlock(num);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
        }
    });
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
