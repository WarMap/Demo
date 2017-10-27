//
//  BinaryTree.m
//  algorithm
//
//  Created by warmap on 2017/10/27.
//  Copyright © 2017年 warmap. All rights reserved.
//

#import "BinaryTree.h"

typedef struct TreeNode{
    int value;
    struct TreeNode *leftNode;
    struct TreeNode *rightNode;
} TreeNode;

@interface Node : NSObject

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) Node *leftNode;
@property (nonatomic, strong) Node *rightNode;

@end

@implementation Node

- (instancetype)initWithValue:(NSUInteger)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

@end

@implementation BinaryTree {
    Node *_rootNode;
}

/**
 创建二叉排序树
                   20
             15          22
          13    16    21    26
 */
- (void)createTree {
    _rootNode = [[Node alloc] initWithValue:20];
    Node *node15 = [[Node alloc] initWithValue:15];
    Node *node13 = [[Node alloc] initWithValue:15];
    Node *node16 = [[Node alloc] initWithValue:15];
    Node *node22 = [[Node alloc] initWithValue:15];
    Node *node21 = [[Node alloc] initWithValue:15];
    Node *node26 = [[Node alloc] initWithValue:15];
    
    _rootNode.leftNode = node15;
    node15.leftNode = node13;
    node15.rightNode = node16;
    _rootNode.rightNode = node22;
    node22.leftNode = node21;
    node22.rightNode = node26;
}

- (void)depathOfTree {
    NSLog(@"二叉树的深度为  %ld",[self depthWithRootNode:_rootNode]);
}

- (NSInteger)depthWithRootNode:(Node *)rootNode {
    if (!rootNode) {
        return 0;
    }
    if (!rootNode.rightNode && !rootNode.leftNode) {
        return 1;
    }
    NSInteger leftDepth = [self depthWithRootNode:rootNode.leftNode];
    NSInteger rightDepth = [self depthWithRootNode:rootNode.rightNode];
    return MAX(leftDepth, rightDepth) + 1;
}

- (void)invertTree {
    
}


@end
