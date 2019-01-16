//
//  SomeClass+one.m
//  Category
//
//  Created by Ma,Peng on 2019/1/15.
//  Copyright © 2019 warmap. All rights reserved.
//

#import "SomeClass+one.h"

@implementation SomeClass (one)

+ (void)classMethod1 {
    printf("i'm the categroy one %s", __func__);
}
+ (void)classMethod2 {
    printf("i'm the categroy one %s", __func__);
}
+ (void)classMethod3 {
    printf("i'm the categroy one %s", __func__);
}


- (void)Method1 {
    printf("i'm the categroy one %s", __func__);
}
- (void)Method2 {
    printf("i'm the categroy one %s", __func__);
}
- (void)Method3 {
    printf("i'm the categroy one %s", __func__);
}

- (void)setAge:(int)age {
    
}

- (int)age {
    return 3;
}
@end
