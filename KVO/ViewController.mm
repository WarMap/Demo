//
//  ViewController.m
//  KVO
//
//  Created by warmap on 2017/10/31.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "ViewController.h"
#import "MPPerson.h"
#import "NSObject+MPKVO.h"
#import "MJClassInfo.h"
#import "MPSomeClass.h"

@interface ViewController ()

@property (nonatomic, strong) MPPerson *person1;
@property (nonatomic, strong) MPPerson *person2;
@property (nonatomic, strong) MPSomeClass *someClass;
//@property (nonatomic, strong) NSDate *date;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 self.someClass= [[MPSomeClass alloc] init];
    
    [self testKVC];
}

- (void)testKVC {
    [self.someClass addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    [self.someClass setValue:@10 forKey:@"age"];
    [self.someClass removeObserver:self forKeyPath:@"age"];
}
- (void)testKVO {
    self.person1 = [[MPPerson alloc] init];
    self.person2 = [[MPPerson alloc] init];
    
    printf("%s\n",object_getClassName(self.person1)) ;
    printf("%s\n",object_getClassName(self.person2)) ;
    [self.person1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    printf("%s\n",object_getClassName(self.person1)) ;
    
    printf("%s\n",object_getClassName(self.person2)) ;
    mj_objc_class *cls = (__bridge mj_objc_class *)[self.person1 class];
    mj_objc_class *meta = cls->metaClass();
    printf("");
}

- (void)test {
        [self.person1 MP_addObserver:self forKey:@"name" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
            NSLog(@"\n observedObject is %@\n observedKey is %@\n oldValue is %@\n newValue is %@", observedObject, observedKey, oldValue, newValue);
        }];
    //    [self addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testKVC];
//    self.person1.name = [NSString stringWithFormat:@"killer%d", (arc4random() % 100)];
//    NSLog(@"1");
//    [self willChangeValueForKey:@"date"]; // “手动触发self.now的KVO”，必写。
//    NSLog(@"2");
//    [self didChangeValueForKey:@"date"]; // “手动触发self.now的KVO”，必写。
//    NSLog(@"4");

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    printf("observeValueForKeyPath");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
