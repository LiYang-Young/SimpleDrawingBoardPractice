//
//  DrawView.m
//  画板
//
//  Created by 李洋 on 2018/7/19.
//  Copyright © 2018年 com.appTest.app. All rights reserved.
//

#import "DrawView.h"
#import "MyUIBezierPath.h"
@interface DrawView ()
{}
@property (nonatomic,strong) MyUIBezierPath *bezierPath;
@property (nonatomic,strong) NSMutableArray *pathArray;
// 线宽
@property (nonatomic,assign) CGFloat width;
// 颜色
@property (nonatomic,strong) UIColor * lineColor;

@end

@implementation DrawView

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.pathArray addObject:_image];
    [self setNeedsDisplay];
}

- (NSMutableArray *)pathArray
{
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.width = 1;
    self.lineColor = [UIColor blackColor];
    
    
}


// 清屏
- (void)clear
{
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

// 撤销
- (void)undo
{
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}

// 擦除
- (void)eraser
{
    [self color:[UIColor whiteColor]];
}

// 颜色
- (void)color:(UIColor *)color
{
    self.lineColor = color;
}

// 粗细
- (void)lineWidthWidth:(CGFloat)width
{
    self.width = width;
}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        MyUIBezierPath * path = [[MyUIBezierPath alloc] init];
        self.bezierPath = path;
        [path moveToPoint:[pan locationInView:self]];
        [path setLineWidth:self.width];
        path.color = self.lineColor;
        [self.pathArray addObject:path];
        
    }else if(pan.state == UIGestureRecognizerStateChanged)
    {
        [self.bezierPath addLineToPoint:[pan locationInView:self]];
    }
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (MyUIBezierPath * path in self.pathArray) {
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage * image = (UIImage *)path;
            [image drawInRect:self.bounds];
            continue;
        }
        [path.color set];
        [path stroke];
    }
}

@end
