//
//  MPSomeClass.m
//  KVO
//
//  Created by Ma,Peng on 2019/1/15.
//  Copyright © 2019 warmap. All rights reserved.
//

#import "MPSomeClass.h"


@implementation MPSomeClass

- (void)setAge:(int)age {
    printf("%s", __func__);
    _age = age;
}

- (void)_setAge:(int)age {
    
}
@end
