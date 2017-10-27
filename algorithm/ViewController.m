//
//  ViewController.m
//  algorithm
//
//  Created by warmap on 2017/10/26.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "ViewController.h"
#import "BinaryTree.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testBinaryTree];
}

- (void)testBinaryTree {
    BinaryTree *tree = [BinaryTree new];
    [tree createTree];
    [tree depathOfTree];
    [tree invertTree];
}

- (void)testQuickSort {
    NSMutableArray *array = @[@5, @1, @3, @8, @4, @9].mutableCopy;
    [self quickSort:array start:0 end:array.count-1];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"第%ld个数字为%@", idx, obj);
    }];
}

- (void)quickSort:(NSMutableArray<NSNumber *> *)array start:(NSInteger)start end:(NSInteger)end {
    if (start < end) {
        NSInteger index = [self partition:array start:start end:end];
        [self quickSort:array start:start end:index-1];
        [self quickSort:array start:index+1 end:end];
    }
}

- (NSInteger)partition:(NSMutableArray<NSNumber *> *)array start:(NSInteger)start end:(NSInteger)end {
    NSInteger x = array[end].integerValue;
    NSInteger i = start - 1;
    for (NSInteger j = start; j < end; j++) {
        NSInteger temp = array[j].integerValue;
        if (temp <= x) {
            i = i+1;
            if (i != j) {
                array[j] = array[i];
                array[i] = @(temp);
            }
        }
    }
    NSInteger temp = array[i+1].integerValue;
    array[i+1] = array[end];
    array[end] = @(temp);
    return (i + 1);
}

- (void)testBinarySearch {
    NSArray *numberArray = @[@1, @3, @27, @36, @42, @70, @82];
    NSInteger index = [self binarySearch:numberArray key:70];
    NSLog(@"70 位于第%ld个数", index);
}

/**
 二分查找，while形式

 @param array <#array description#>
 @param key <#key description#>
 @return <#return value description#>
 */
- (NSInteger)binarySearch:(NSArray<NSNumber *> *)array key:(NSInteger)key {
    NSInteger low, mid, high;
    low = 0;
    high = array.count-1;
    while (high >= low) {
        mid = (low + high)/2;
        NSInteger value = array[mid].integerValue;
        if (value > key) {
            high = mid - 1;
        } else if (value < key) {
            low = mid + 1;
        } else {
            return (mid + 1);
        }
    }
    return -1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
