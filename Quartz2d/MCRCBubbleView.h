//
//  MCRCBubbleView.h
//  StretchDemo
//
//  Created by Sword on 28/09/2016.
//  Copyright © 2016 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCRCBubbleView : UIView

@property (nonatomic, assign, readonly) CGFloat bubbleHeight;

+ (CGFloat)bubbleViewHeight;
+ (CGFloat)marginX;
- (UIImage *)transfer2image;

@end
