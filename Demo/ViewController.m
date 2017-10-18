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

@end

@implementation ViewController
#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self timerFire];  //拉取一次数据
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
    if (!self.thread.isCancelled) {
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
}

- (void)singleThreadMethod {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
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
