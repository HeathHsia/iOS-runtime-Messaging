//
//  UIViewController+ViewDidLoadName.m
//  MethodSwizzlingIMPdemo
//
//  Created by 帝炎魔 on 16/5/12.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "UIViewController+ViewDidLoadName.h"
#import <objc/runtime.h>

// 有返回值的IMP
typedef id (* _IMP) (id, SEL, ...);
// 没有返回值的IMP(定义为VIMP)
typedef void (* _VIMP) (id, SEL, ...);

@implementation UIViewController (ViewDidLoadName)


+(void)load
{
    // 保证交换方法只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 获取原始方法
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        // 获取原始方法的实现指针(IMP)
        _VIMP viewDidLoad_IMP = (_VIMP)method_getImplementation(viewDidLoad);
        
        // 重新设置方法的实现
        method_setImplementation(viewDidLoad, imp_implementationWithBlock(^(id target, SEL action) {
            // 调用系统的原生方法
            viewDidLoad_IMP(target, @selector(viewDidLoad));
            // 新增的功能代码
            NSLog(@"%@ did load", target);
        }));
        
    });
}

//+ (void)load
//{
//    // 保证交换方法只执行一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 获取到这个类的viewDidLoad方法, 它的类型是一个objc_method结构体的指针
//        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
//        
//        // 获取到自己刚刚创建的一个方法
//        Method myViewDidLoad = class_getInstanceMethod(self, @selector(myViewDidLoad));
//        
//        // 交换两个方法的实现
//        method_exchangeImplementations(viewDidLoad, myViewDidLoad);
//        
//      
//        
//    });
//}
//
//- (void)myViewDidLoad
//{
//    // 调用系统的方法
//    [self myViewDidLoad];
//    NSLog(@"%@ did load", self);
//}

@end
