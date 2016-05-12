//
//  Car.m
//  MethodSwizzlingIMPdemo
//
//  Created by 帝炎魔 on 16/5/12.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "Car.h"

@implementation Car


- (void)run
{
     NSLog(@"%@ %s", self, sel_getName(_cmd));
}
@end
