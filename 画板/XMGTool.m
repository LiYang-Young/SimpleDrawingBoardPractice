//
//  XMGTool.m
//  画板
//
//  Created by 李洋 on 2018/9/5.
//  Copyright © 2018年 com.appTest.app. All rights reserved.
//

#import "XMGTool.h"

@implementation XMGTool

static XMGTool * _instance;


+ (instancetype)shareTool
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
