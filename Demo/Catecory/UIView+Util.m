//
//  UIView+Util.m
//  Demo
//
//  Created by warmap on 2017/10/18.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "UIView+Util.h"
#import <objc/runtime.h>

static NSString * associatedKey = nil;
static int GetViewLayerNum(UIView * aimView)
{
    if (associatedKey == nil) {
        associatedKey = @"kMyViewInheritNum";
    }
    
    int viewLayer = 0;
    NSNumber * count = objc_getAssociatedObject(aimView, [associatedKey UTF8String]);
    if (count) {
        viewLayer = [count intValue];
    } else {
        UIView * rootView = [UIApplication sharedApplication].keyWindow;
        int layerCount = 0;
        UIView * tView = aimView;
        while (tView != rootView) {
            layerCount ++;
            tView = tView.superview;
            
            if (tView == nil) {
                break;
            }
        }
        objc_setAssociatedObject(aimView, [associatedKey UTF8String], @(layerCount), OBJC_ASSOCIATION_ASSIGN);
        viewLayer = layerCount;
    }
    return viewLayer;
}

@implementation UIView (Util)

//+ (void)load {
//    method_exchangeImplementations(class_getInstanceMethod(self, @selector(hitTest:withEvent:)), class_getInstanceMethod(self, @selector(mp_hitTest:withEvent:)));
//    method_exchangeImplementations(class_getInstanceMethod(self, @selector(pointInside:withEvent:)), class_getInstanceMethod(self, @selector(mp_pointInside:withEvent:)));
//}

- (UIView *)mp_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [self mp_hitTest:point withEvent:event];
    if (self == result && self.class != NSClassFromString(@"UIStatusBarWindow")) {
        [self showHitTest];
    }
    [self buildLogWithInfo:[NSString stringWithFormat:@"hit test %@ %p: %@", [self class], self, result ? @"Y" : @"N"]];
    return result;
}

- (BOOL)mp_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [self mp_pointInside:point withEvent:event];
    [self buildLogWithInfo:[NSString stringWithFormat:@"point in %@ %p: %@", [self class], self, result ? @"Y" : @"N"]];
    return result;
}

- (NSString *)buildLogWithInfo:(NSString *)info {
    int layer = GetViewLayerNum(self);
    NSMutableString * mStr = info.mutableCopy;
    while (layer > 0) {
        [mStr insertString:@"-" atIndex:0];
        layer --;
    }
    printf("%s\n", [mStr UTF8String]);
    return mStr;
}

- (void)showHitTest {
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectInset(self.bounds, -10, -10);
    } completion:^(BOOL finished) {
        self.bounds = CGRectInset(self.bounds, 10, 10);
    }];
}

@end
