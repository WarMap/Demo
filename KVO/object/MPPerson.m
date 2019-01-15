//
//  MPPerson.m
//  KVO
//
//  Created by warmap on 2017/10/31.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "MPPerson.h"


@implementation MPPerson

- (void)didChangeValueForKey:(NSString *)key {
    printf("begin  %s\n", __func__);
    [super didChangeValueForKey:key];
    printf("begin  %s\n", __func__);
}

- (void)setName:(NSString *)name {
    printf("begin  %s\n", __func__);
    _name = [name copy];
    printf("begin  %s\n", __func__);
}

- (void)willChangeValueForKey:(NSString *)key {
    printf("begin  %s\n", __func__);
    [super willChangeValueForKey:key];
    printf("end    %s\n", __func__);
}
@end
