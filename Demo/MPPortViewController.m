//
//  MPPortViewController.m
//  Demo
//
//  Created by warmap on 2017/10/30.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "MPPortViewController.h"

@interface MPPortViewController ()<NSMachPortDelegate> {
    CFRunLoopRef _runloopRef;
    CFRunLoopSourceRef _source;
    CFRunLoopSourceContext _sourceContext;
}

@end

@implementation MPPortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testCustomSource];
}

- (void)testPort {
    NSMachPort *mainPort = [NSMachPort new];
    NSMachPort *threadPort = [NSMachPort new];
    
    threadPort.delegate = self;
    
    [[NSRunLoop currentRunLoop] addPort:mainPort forMode:NSDefaultRunLoopMode];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSRunLoop currentRunLoop] addPort:threadPort forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
    NSString *msg = @"hello";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[mainPort, data]];
        [threadPort sendBeforeDate:[NSDate date] msgid:1000 components:array from:mainPort reserved:0];
    });
    
}

//这个NSMachPort收到消息的回调，注意这个参数，可以先给一个id。如果用文档里的NSPortMessage会发现无法取值
- (void)handlePortMessage:(id)message {
    NSLog(@"收到消息了，线程为：%@",[NSThread currentThread]);
    
    //只能用KVC的方式取值
    NSArray *array = [message valueForKeyPath:@"components"];
    
    NSData *data =  array[1];
    NSString *s1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",s1);
    
    //    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    //    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];
}

- (void)testCustomSource {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@--thread start", [NSThread currentThread]);
        
        _runloopRef = CFRunLoopGetCurrent();
        
        bzero(&_sourceContext, sizeof(_sourceContext));
        _sourceContext.perform = fire;
        _sourceContext.info = "hello";
        
        _source = CFRunLoopSourceCreate(NULL, 0, &_sourceContext);
        CFRunLoopAddSource(_runloopRef, _source, kCFRunLoopDefaultMode);
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 999999999, YES);
        NSLog(@"end thread");
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (CFRunLoopIsWaiting(_runloopRef)) {
            NSLog(@"runloop is waiting");
            CFRunLoopSourceSignal(_source);
            CFRunLoopWakeUp(_runloopRef);
        } else {
            NSLog(@"runloop is prcessing");
            CFRunLoopSourceSignal(_source);
        }
    });
}

static void fire(void *info) {
    NSLog(@"I'm processing task in background");
    printf("%s", info);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
