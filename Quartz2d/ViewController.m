//
//  ViewController.m
//  Quartz2d
//
//  Created by Ma,Peng on 2018/1/8.
//  Copyright © 2018年 warmap. All rights reserved.
//

#import "ViewController.h"
#import "MCRCBubbleView.h"

static CGFloat bigBubbleHeight = 50;
static CGFloat bigBubbleWidth = 160;


@interface ViewController ()

@property (nonatomic, strong) MCRCBubbleView *bigBubbleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self customSubview];
}

- (void)customSubview {
    _bigBubbleView = [[MCRCBubbleView alloc] init];
    self.bigBubbleView.frame = CGRectMake(100, 200, bigBubbleWidth, bigBubbleHeight);
    UIImage *iamge = [self.bigBubbleView transfer2image];
    UIImageView *iamgeview = [[UIImageView alloc] initWithImage:iamge];
    iamgeview.frame = self.bigBubbleView.frame;
    [self.view addSubview:iamgeview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
