//
//  NSObject+DeallocBlock.m
//  pengpeng
//
//  Created by jianwei.chen on 15/9/6.
//  Copyright (c) 2015年 AsiaInnovations. All rights reserved.
//

#import "NSObject+DeallocBlock.h"
#import <objc/message.h>

@interface NBDeallocBlockExecutor : NSObject{
    dispatch_block_t _block;
}
- (id)initWithBlock:(dispatch_block_t)block;
@end

@implementation NBDeallocBlockExecutor
- (id)initWithBlock:(dispatch_block_t)aBlock
{
    self = [super init];
    if (self) {
        _block = [aBlock copy];
    }
    return self;
}
- (void)dealloc
{
    _block ? _block() : nil;
}
@end


static char *dealloc_key;
@implementation NSObject (DeallocBlock)

-(void)runAtDealloc:(dispatch_block_t)block
{
    if(block){
        NBDeallocBlockExecutor *executor = [[NBDeallocBlockExecutor alloc] initWithBlock:block];
        objc_setAssociatedObject(self, &dealloc_key, executor, OBJC_ASSOCIATION_RETAIN);//不要强应用
    }
}

// 添加一个监听者
- (void)addObserverForRunloop {
    
    // 1. 创建监听者
    /**
     *  创建监听者
     *
     *   allocator#>  分配存储空间
     *   activities#> 要监听的状态
     *   repeats#>    是否持续监听
     *   order#>      优先级, 默认为0
     *   observer     观察者
     *   activity     监听回调的当前状态
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        /*
         kCFRunLoopEntry = (1UL << 0),          进入工作
         kCFRunLoopBeforeTimers = (1UL << 1),   即将处理Timers事件
         kCFRunLoopBeforeSources = (1UL << 2),  即将处理Source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),  即将休眠
         kCFRunLoopAfterWaiting = (1UL << 6),   被唤醒
         kCFRunLoopExit = (1UL << 7),           退出RunLoop
         kCFRunLoopAllActivities = 0x0FFFFFFFU  监听所有事件
         */
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理Timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理Source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"退出RunLoop");
                break;
            default:
                break;
        }
    });
    
    // 2. 添加监听者
    /**
     *  给指定的RunLoop添加监听者
     *
     *  @param rl#>       要添加监听者的RunLoop
     *  @param observer#> 监听者对象
     *  @param mode#>     RunLoop的运行模式, 填写默认模式即可
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

@end
