//
//  ViewController.m
//  画板
//
//  Created by 李洋 on 2018/7/19.
//  Copyright © 2018年 com.appTest.app. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@property (nonatomic,strong) UIView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
// 清屏
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}
// 撤销
- (IBAction)undo:(id)sender {
    [self.drawView undo];
}
// 擦除
- (IBAction)eraser:(id)sender {
    [self.drawView eraser];
}
// 颜色
- (IBAction)color:(UIButton *)sender {
    [self.drawView color:sender.backgroundColor];
}
// 粗细
- (IBAction)lineWidthSlider:(UISlider *)sender {
    [self.drawView lineWidthWidth:sender.value];
}


// 相册
- (IBAction)photo:(id)sender {
    UIImagePickerController * pick = [[UIImagePickerController alloc] init];
    pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    
    [self.drawView addSubview:self.imageView];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageView.bounds.size.width, self.imageView.bounds.size.height)];
    imageV.image = image;
    imageV.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [imageV addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    [imageV addGestureRecognizer:pin];
    
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [imageV addGestureRecognizer:rotation];
    
    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longP:)];
    [imageV addGestureRecognizer:longP];
    
    
    [self.imageView addSubview:imageV];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 保存
- (IBAction)save:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 1);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存成功");
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, point.y);
    // 复位
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)pin:(UIPinchGestureRecognizer *)pin
{
    pin.view.transform = CGAffineTransformScale(pin.view.transform, pin.scale, pin.scale);
    // 复位
    [pin setScale:1];
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    // 复位
    rotation.rotation = 0;
}

- (void)longP:(UILongPressGestureRecognizer *)longP
{
    if (longP.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.5 animations:^{
            longP.view.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                longP.view.alpha = 1;
            }];
        }];
    }else if (longP.state == UIGestureRecognizerStateEnded)
    {
        // 开启图片上下文
        UIGraphicsBeginImageContext(self.imageView.bounds.size);
        // 将view渲染到上下文中 只能用layer
        [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        // 生成一张图片
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.drawView.image = image;
        
        [self.imageView removeFromSuperview];
        
        [self.imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    }
}

- (UIView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.drawView.bounds.size.width, self.drawView.bounds.size.height)];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
