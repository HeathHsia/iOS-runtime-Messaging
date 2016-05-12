//
//  ViewController.m
//  MethodSwizzlingIMPdemo
//
//  Created by 帝炎魔 on 16/5/12.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ViewDidLoadName.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 创建Person对象 执行run方法, 但是Person类中并没有实现run方法
    // 我们利用消息转发机制防止其崩溃,或者用其他方法来代替[per run]的方法
    Person *per = [[Person alloc] init];
    [per run];
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
