//
//  NSObject+DeallocBlock.h
//  pengpeng
//
//  Created by jianwei.chen on 15/9/6.
//  Copyright (c) 2015年 AsiaInnovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocBlock)

-(void)runAtDealloc:(dispatch_block_t)block;

// 添加一个监听者
- (void)addObserverForRunloop;

@end
