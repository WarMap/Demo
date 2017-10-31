//
//  ViewController.m
//  Block
//
//  Created by warmap on 2017/10/30.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "ViewController.h"

//A better version of NSLog
#define NSLog(format, ...) do { \
fprintf(stderr, "<%s : %d> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__); \
(NSLog)((format), ##__VA_ARGS__); \
fprintf(stderr, "-------\n"); \
} while (0)


@interface ViewController ()

@property (nonatomic, strong) void (^copyBlock)(void);
@property (nonatomic, assign) NSUInteger count;
@end

int global_i = 1;
static int static_global_i = 1;

/**
 使用clang工具研究block
 clang -rewrite-objc 文件名.c

 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self);
    self.count = 3;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", self)、
    
    [self testVar];
}

/**
 1. 不使用的自动变量或者静态变量并不会被捕捉到block内，block只会捕捉内部要用到的值
 2. block不会捕捉形参
 */
- (void)testVar {
    static int static_k = 1;  //会捕获内存地址
    int val = 1;  //Block仅仅捕获了val的值，并没有捕获val的内存地址
    NSMutableString *str = @"hello".mutableCopy;
    
    void(^myBlock)(void) = ^{
        global_i++;
        static_global_i++;
        static_k++;
        [str appendString:@" warmap"];
        NSLog(@"%@",str);
//        val++;
        NSLog(@"\n global_i = %d,\n static_global_i = %d,\n static_k = %d", global_i, static_global_i, static_k);
    };
    global_i++;
    static_global_i++;
    static_k++;
    val++;
    NSLog(@"\n global_i = %d,\n static_global_i = %d,\n static_k = %d,\n val = %d", global_i, static_global_i, static_k, val);
    NSLog(@"%@", str);
    /*
     只用到外部局部变量、成员属性变量，且没有强指针引用的block都是StackBlock。
     StackBlock的生命周期由系统控制的，一旦返回之后，就被系统销毁了。
     */
    NSLog(@"block --%@", ^{ NSLog(@"hahhahahhahahhah%d", val);});
    NSLog(@"block --%@", ^{ NSLog(@"hahhahahhahahhah%d", self.count);});
    /*
     没有用到外界变量或只用到全局变量、静态变量的block为_NSConcreteGlobalBlock，
     生命周期从创建到应用程序结束。
     */
    NSLog(@"block --%@", ^{ NSLog(@"hahhahahhahahhah");});
    NSLog(@"block --%@", ^{ NSLog(@"hahhahahhahahhah%d,%d,%d", static_global_i, static_k, global_i);});
    /*
    有强指针引用或copy修饰的成员属性引用的block会被复制一份到堆中成为MallocBlock，
     没有强指针引用即销毁，生命周期由程序员控制 (满足这个条件但是同时满足上面GlobalBlock的条件，会成为GlobalBlock)
     */
    NSLog(@"block --%@", myBlock);
    self.copyBlock = ^{NSLog(@"copy block, %d", val);};//这里用了局部变量所以为mallocBlock，如果没用的话则为GlobalBlock
    NSLog(@"block --%@", self.copyBlock);
   
    /*
     1.手动调用copy
     2.Block是函数的返回值
     3.Block被强引用，Block被赋值给__strong或者id类型
     4.调用系统API入参中含有usingBlcok的方法
     
     以上4种情况，系统都会默认调用copy方法把Block赋复制
     
     */
    
/*
 从持有对象的角度上来看：
 _NSConcreteStackBlock是不持有对象的。
 _NSConcreteMallocBlock是持有对象的。
 _NSConcreteGlobalBlock也不持有对象
 */
    myBlock();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
