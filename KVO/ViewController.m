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

@interface ViewController ()

@property (nonatomic, strong) MPPerson *person;
@property (nonatomic, strong) NSDate *date;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.person MP_addObserver:self forKey:@"name" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"\n observedObject is %@\n observedKey is %@\n oldValue is %@\n newValue is %@", observedObject, observedKey, oldValue, newValue);
    }];
    [self addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = [NSString stringWithFormat:@"killer%d", (arc4random() % 100)];
    NSLog(@"1");
    [self willChangeValueForKey:@"date"]; // “手动触发self.now的KVO”，必写。
    NSLog(@"2");
    [self didChangeValueForKey:@"date"]; // “手动触发self.now的KVO”，必写。
    NSLog(@"4");

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"3");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MPPerson *)person {
    if (!_person) {
        _person = [[MPPerson alloc] init];
    }
    return _person;
}


@end
