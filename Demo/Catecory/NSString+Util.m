//
//  NSString+Util.m
//  Demo
//
//  Created by warmap on 2017/10/18.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (NSString *)stringWithDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss:SSSS"];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    return [formatter stringFromDate:now];
}
@end
