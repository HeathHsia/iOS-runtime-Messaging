//
//  Person.m
//  MethodSwizzlingIMPdemo
//
//  Created by 帝炎魔 on 16/5/12.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Car.h"

@implementation Person

/**
 *  首先，该方法在调用时，系统会查看这个对象能否接收这个消息（查看这个类有没有这个方法，或者有没有实现这个方法。），如果不能并且只在不能的情况下，就会调用下面这几个方法，给你“补救”的机会，你可以先理解为几套防止程序crash的备选方案，我们就是利用这几个方案进行消息转发，注意一点，前一套方案实现后一套方法就不会执行。如果这几套方案你都没有做处理，那么程序就会报错crash。
    
    方案一：
 
    + (BOOL)resolveInstanceMethod:(SEL)sel
    + (BOOL)resolveClassMethod:(SEL)sel
 
    方案二：
 
    - (id)forwardingTargetForSelector:(SEL)aSelector
 
    方案三：
 
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
    - (void)forwardInvocation:(NSInvocation *)anInvocation;
 
*/

void run (id self, SEL _cmd)
{
    // 程序会走我们C语言的部分
    NSLog(@"%@ %s", self, sel_getName(_cmd));
}


/**
 *   方案一
 *
 *   为Person类动态增加了run方法的实现
    由于没有实现run对应的方法, 那么系统会调用resolveInstanceMethod让你去做一些其他操作
 */

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
//    if(sel == @selector(run)) {
//        class_addMethod([self class], sel, (IMP)run, "v@:");
//        return YES;
//    }
    return [super respondsToSelector:sel];
}

/** 方案二
 *  现在不对方案一做任何的处理, 直接调用父类的方法
    系统会走到forwardingTargetForSelector方法
 */

//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    return [[Car alloc] init];
//}


/**
 *   不实现forwardingTargetForSelector,
     系统就会调用方案三的两个方法
    methodSignatureForSelector 和 forwardInvocation
 */

/**
 *  方案三
    开头我们要找的错误unrecognized selector sent to instance原因，原来就是因为methodSignatureForSelector这个方法中，由于没有找到run对应的实现方法，所以返回了一个空的方法签名，最终导致程序报错崩溃。
 
     所以我们需要做的是自己新建方法签名，再在forwardInvocation中用你要转发的那个对象调用这个对应的签名，这样也实现了消息转发。
  */

/**
 *  methodSignatureForSelector
 *  用来生成方法签名, 这个签名就是给forwardInvocation中参数NSInvocation调用的
 *
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    // 判断你要转发的SEL
    if ([sel isEqualToString:@"run"]) {
        // 为你的转发方法手动生成签名
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
        
    }
    return [super methodSignatureForSelector:aSelector];
}
/**
 *  关于生成签名类型"v@:"解释一下, 每个方法会默认隐藏两个参数, self, _cmd
    self 代表方法调用者, _cmd 代表这个方法SEL, 签名类型就是用来描述这个方法的返回值, 参数的, 
    v代表返回值为void, @表示self, :表示_cmd
 */
-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    // 新建需要转发消息的对象
    Car *car = [[Car alloc] init];
    if ([car respondsToSelector:selector]) {
        // 唤醒这个方法
        [anInvocation invokeWithTarget:car];
    }
}

@end
