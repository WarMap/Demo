//
//  SomeClass+one.h
//  Category
//
//  Created by Ma,Peng on 2019/1/15.
//  Copyright © 2019 warmap. All rights reserved.
//

#import "SomeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface SomeClass (one)<NSObject>

@property (nonatomic, assign) int age;

+ (void)classMethod1;
+ (void)classMethod2;
+ (void)classMethod3;

- (void)Method1;
- (void)Method2;
- (void)Method3;

@end

NS_ASSUME_NONNULL_END
