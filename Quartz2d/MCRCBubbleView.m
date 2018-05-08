//
//  MCRCBubbleView.m
//  StretchDemo
//
//  Created by Sword on 28/09/2016.
//  Copyright © 2016 Baidu. All rights reserved.
//

#import "MCRCBubbleView.h"

@interface MCRCBubbleView()

@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@end

@implementation MCRCBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleHeight = 5;
        self.opaque = FALSE;
        self.backgroundColor = [UIColor clearColor];
        
        _bubbleLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_bubbleLayer];
        [self setupBubbleEffect];

    }
    return self;
}

- (CGPathRef)bubblePath {
    CGFloat radius = CGRectGetHeight(self.bounds) / 2.0 - 3;
    CGFloat bubbleHeight = _bubbleHeight;
    CGFloat bubbleWidth = 8;
    CGFloat drawWidth = CGRectGetWidth(self.bounds);
    CGFloat drawHeight = CGRectGetHeight(self.bounds) - bubbleHeight;
    
    //left corner
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    CGPathMoveToPoint(bubblePath, NULL, radius, 0);
    CGPathAddArcToPoint(bubblePath, NULL, 0, 0, 0, radius, radius);
    
    //left-bottom corner
    CGPathAddLineToPoint(bubblePath, NULL, 0, drawHeight - radius);
    CGPathAddArcToPoint(bubblePath, NULL, 0, drawHeight, radius, drawHeight, radius);
    
    //bottom down-arrow
    CGPathAddLineToPoint(bubblePath, NULL, (drawWidth - bubbleWidth) / 2, drawHeight);
    CGPathAddLineToPoint(bubblePath, NULL, drawWidth / 2, drawHeight + bubbleHeight);
    CGPathAddLineToPoint(bubblePath, NULL, (drawWidth + bubbleWidth) / 2, drawHeight);
    
    //right-bottom corner
    CGPathAddLineToPoint(bubblePath, NULL, drawWidth - radius, drawHeight);
    CGPathAddArcToPoint(bubblePath, NULL, drawWidth, drawHeight, drawWidth, drawHeight - radius, radius);
    
    //right-top corner
    CGPathAddLineToPoint(bubblePath, NULL, drawWidth, radius);
    CGPathAddArcToPoint(bubblePath, NULL, drawWidth, 0, drawWidth - radius, 0, radius);
    
    //move brush to start point
    CGPathAddLineToPoint(bubblePath, NULL, radius, 0);
    
    return bubblePath;
}

- (void)setupBubbleEffect {
    CGPathRef bubblePath = [self bubblePath];
    
    CGColorRef shadowColor = CGColorCreateCopyWithAlpha([UIColor blackColor].CGColor, 1.0);
    self.layer.shadowColor = shadowColor;
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowPath = bubblePath;
    self.layer.borderColor =  [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.0;
    CGColorRelease(shadowColor);
    
    _bubbleLayer.frame = self.bounds;
    _bubbleLayer.fillColor = [UIColor whiteColor].CGColor;
    _bubbleLayer.lineWidth = 0.0;
    _bubbleLayer.strokeColor = [UIColor clearColor].CGColor;
    _bubbleLayer.path = bubblePath;
    CGPathRelease(bubblePath);
}

- (UIImage *)transfer2image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupBubbleEffect];
}

+ (CGFloat)bubbleViewHeight {
    return 45;
}

+ (CGFloat)marginX {
    return 12;
}
@end
