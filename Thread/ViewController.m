//
//  ViewController.m
//  Thread
//
//  Created by warmap on 2017/10/30.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)testAsyncSerial {
    NSLog(@"ready to go %@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.warmap.test", 0);
    dispatch_async(queue, ^{
        NSLog(@"this is async task %@", [NSThread currentThread]);
    });
    NSLog(@"finished");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
