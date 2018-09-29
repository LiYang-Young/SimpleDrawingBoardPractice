//
//  DrawView.h
//  画板
//
//  Created by 李洋 on 2018/7/19.
//  Copyright © 2018年 com.appTest.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,strong) UIImage *image;

// 清屏
- (void)clear;

// 撤销
- (void)undo;

// 擦除
- (void)eraser;

// 颜色
- (void)color:(UIColor *)color;

// 粗细
- (void)lineWidthWidth:(CGFloat)width;

@end
