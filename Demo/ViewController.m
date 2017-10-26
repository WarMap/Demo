//
//  ViewController.m
//  Demo
//
//  Created by warmap on 2017/10/18.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Util.h"
#import "NSObject+DeallocBlock.h"

/**
 需求：进入页面拉取一次数据，然后每2秒拉取一次数据，还可手动调用拉取数据，页面不可见的时候不拉取
 */
@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, assign) BOOL requestIsFlying;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSPort *myPort;

@end

@implementation ViewController
#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self timerFire];  //拉取一次数据
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startFetch];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self endFetch];
}

#pragma mark -
#pragma mark - events
- (IBAction)didClickEnd:(id)sender {
    [self endFetch];
}
- (IBAction)didClickStart:(id)sender {
    [self startFetch];
}
- (IBAction)didClickFetch:(id)sender {
    [self timerFire];
}

#pragma mark -
#pragma mark - private methods
- (void)startFetch {
    if (!self.thread) {
        [self openThreadFetch];
    }
}

- (void)endFetch {
    if (self.thread && !self.thread.isCancelled) {
        [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
        [self.timer invalidate];
        self.timer = nil;
        [self.thread cancel];
        self.thread = nil;
    }
}

- (void)openThreadFetch {
    if (self.thread) {
        return;
    }
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThreadMethod) object:nil];
    [self.thread runAtDealloc:^{
        NSLog(@"thread dealloc");
    }];
    [self.thread start];
    //第三种方式启动NSRunloop的话，解注下面这句话。会结束NSRunloop的执行。
//    [self performSelector:@selector(printSomething) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)singleThreadMethod {
    @autoreleasepool {
        [self addObserverForRunloop];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [[NSRunLoop currentRunLoop] currentMode];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        NSLog(@"thread alloced");
        /*
         NSRunloop的启动方式
         1.    - (void)run;
         2.    - (void)runUntilDate:(NSDate *)limitDate;
         3.    - (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;
         第一种和第二种均是多次调用第三种。而第三种runloop只会跑一次
         官方说明：YES if the run loop ran and processed an input source or if the specified timeout value was reached; otherwise, NO if the run loop could not be started.
         也就是说这个loop执行完一个input source或者到达时限就会返回。即不再loop
         只在runloop中跑timer是可以使用第三种的，因为loop会一直处理timer事件然后休眠，再处理timer事件，再休眠。。。。。。。也不会返回。
         */
        BOOL flag = [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        /*
         用下面这种方式启动也可以
         CFRunLoopRun();
         注意：下面这句话只会结束当前的 runMode:beforeDate: 调用，而不会结束后续的调用。
         CFRunLoopStop(CFRunLoopGetCurrent());
         */
        NSLog(@"runloop return %@", @(flag));
    }
}

- (void)timerFire {
    [self refreshMessage];
}

- (void)stopThread {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)refreshMessage {
    if (!self.requestIsFlying) {
        NSLog(@"请求要发送了。。。。。。。。。。");
        self.requestIsFlying = YES;
        [self loadData];
    } else {
        NSLog(@"请求正在发送。。。。。。。。。。");
    }
}

- (void)loadData {
    NSLog(@"loading data................");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@--loading", [NSString stringWithDate:[NSDate date]]]];
    });
    [NSThread sleepForTimeInterval:0.5];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@--finish", [NSString stringWithDate:[NSDate date]]]];
    });
    NSLog(@"data loaded.................");
    self.requestIsFlying = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
