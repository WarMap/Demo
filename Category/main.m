//
//  main.m
//  Category
//
//  Created by Ma,Peng on 2019/1/15.
//  Copyright © 2019 warmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SomeClass.h"
#import "SomeClass+one.h"
#import "SomeClass+two.h"

int main(int argc, char * argv[]) {
    SomeClass *aInstance = [[SomeClass alloc] init];
    [aInstance someMethod];
    aInstance.age = 2;
    
    return 2;
}
