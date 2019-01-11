//
//  SVCScanViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCScanViewController.h"

#import "SVCSendMainViewController.h"

#import "SVCScanningView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"
#import "UIImage+QRScale.h"

@interface SVCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) SVCScanningView *scanningView;

@property(nonatomic,strong) UIImageView *addImage;
@property(nonatomic,strong) NSMutableArray *pickImages;

//捕获会话
@property (nonatomic,strong) AVCaptureSession *session;

//预览图层，可以通过输出设备展示被捕获的数据流。
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation SVCScanViewController

#pragma mark - Propertys

- (SVCScanningView *)scanningView
{
    if (!_scanningView)
    {
        _scanningView = [[SVCScanningView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
//        [_scanningView.myQRCodeButton addTarget:self action:@selector(myQRCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanningView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRightItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self sweepView];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scanningView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.session stopRunning];
}



-(void)setupRightItem
{
    UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 50)];
    [recordBtn setTitle:Localized(@"album") forState:UIControlStateNormal];
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(showPhotoLibray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:recordBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)sweepView {
    //1.实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; //媒体类型
    
    //2.设置输入设备
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        //防止模拟器崩溃
        //Localized(@"scan.NoCamera")
        return;
    }
    
    //3.设置元数据输出
    //实例化拍摄元数据输出
    AVCaptureMetadataOutput *output=[[AVCaptureMetadataOutput alloc]init];
    //设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //4.添加拍摄会话
    //实例化拍摄会话
    AVCaptureSession *session =[[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];//预设输出质量
    //添加会话输入
    [session addInput:input];
    //添加会话输出
    [session addOutput:output];
    //添加会话输出条码类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    self.session = session;
    
    //5.视频预览图层
    //实例化预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    
    //6.限制扫描范围
    output.rectOfInterest = CGRectMake(80/SVC_ScreenHeight, 55/SVC_ScreenWidth, (SVC_ScreenWidth - 55 * 2)/SVC_ScreenHeight, (SVC_ScreenWidth - 55 * 2)/SVC_ScreenWidth);
    
    //将图层插入当前视图
    [self.view.layer insertSublayer:preview atIndex:100];
    self.previewLayer = preview;
    
    //7.启动会话
    [_session startRunning];
}


- (void)showPhotoLibray
{
    //self.session = nil;
    [self.session stopRunning];
    self.session = nil;
    
    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.navigationBar.barTintColor = SVCV1B1Color;
    imagrPicker.delegate = self;
    //imagrPicker.allowsEditing = YES;
    //将来源设置为相册
    imagrPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum | UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagrPicker animated:YES completion:nil];
}


//获得的数据在此方法中
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    // 3. 设置界面显示扫描结果
    //判断是否有数据
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        //如果需要对url或者名片等信息进行扫描，可以在此进行扩展
        
        [self compareURLWith:obj.stringValue];
    }
}

-(void)compareURLWith:(NSString *)urlStr
{
    NSURL *URL = [NSURL URLWithString:urlStr];
    if (URL)
    {
        if ([urlStr rangeOfString:@"svc://transfer"].location !=NSNotFound)
        {
            NSString *addressAmount = [urlStr componentsSeparatedByString:@"address="][1];
            NSString  *address = [addressAmount componentsSeparatedByString:@"&"][0];
            NSString *amount = [addressAmount componentsSeparatedByString:@"&amount="][1];
            
            SVCSendMainViewController *sendMainVc = [[SVCSendMainViewController alloc] init];
            UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
            temporaryBarButtonItem.title = Localized(@"back");
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            sendMainVc.targetAddress = address;
            sendMainVc.targetAmount = amount;
            [self.navigationController pushViewController:sendMainVc animated:YES];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    NSString *result = [self decodeQRImageWith:image];

    if ( result )
    {
        [self compareURLWith:result];
    }
}

- (NSString *)decodeQRImageWith:(UIImage*)aImage {
    
    NSString *qrResult = nil;
    if (aImage.size.width < 641) {
        aImage = [aImage TransformtoSize:CGSizeMake(640, 640)];
    }
    
    ZBarReaderController* read = [ZBarReaderController new];
    CGImageRef cgImageRef = aImage.CGImage;
    ZBarSymbol* symbol;
    for(symbol in [read scanImage:cgImageRef]) break;
    qrResult = symbol.data ;
    return qrResult;
}

@end
