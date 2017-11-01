//
//  NSObject+MPKVO.h
//  KVO
//
//  Created by warmap on 2017/10/31.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MPObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (MPKVO)

- (void)MP_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(MPObservingBlock)block;

- (void)MP_removeObserver:(NSObject *)observer forKey:(NSString *)key;


@end
