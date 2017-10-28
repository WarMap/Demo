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
#pragma mark -
#pragma mark - public methods
/**
 创建二叉排序树
                   20
             15          22
          13    16    21     26
                                111
 */
- (void)createTree {
    _rootNode = [[Node alloc] initWithValue:20];
    Node *node15 = [[Node alloc] initWithValue:15];
    Node *node13 = [[Node alloc] initWithValue:13];
    Node *node16 = [[Node alloc] initWithValue:16];
    Node *node22 = [[Node alloc] initWithValue:22];
    Node *node21 = [[Node alloc] initWithValue:21];
    Node *node26 = [[Node alloc] initWithValue:26];
    Node *node111 = [[Node alloc] initWithValue:111];
    
    _rootNode.leftNode = node15;
    node15.leftNode = node13;
    node15.rightNode = node16;
    _rootNode.rightNode = node22;
    node22.leftNode = node21;
    node22.rightNode = node26;
    node26.rightNode = node111;
}

- (void)depathOfTree {
    NSLog(@"二叉树的深度为  %ld",[self depthWithRootNode:_rootNode]);
}

- (void)invertTree {
    [self invertBinaryTree:_rootNode];
    NSLog(@"%@", _rootNode);
}

- (void)preOrderTree {
    [self preOrderTraverse:_rootNode];
    NSLog(@"%@", _rootNode);
}

- (void)inOrderTree {
    [self inOrderTraverse:_rootNode];
    NSLog(@"%@", _rootNode);
}

- (void)postOrderTree {
    [self postOrderTraverse:_rootNode];
    NSLog(@"%@", _rootNode);
}

- (void)breadthFirstSearch {
    [self breadthFirstSearch:_rootNode];
}

#pragma mark -
#pragma mark - private methods
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

- (Node *)invertBinaryTree:(Node *)rootNode {
    if (!rootNode) {
        return nil;
    }
    if (!rootNode.rightNode && !rootNode.leftNode) {
        return rootNode;
    }
    Node *left = rootNode.leftNode;
    rootNode.leftNode = rootNode.rightNode;
    rootNode.rightNode = left;
    [self invertBinaryTree:rootNode.leftNode];
    [self invertBinaryTree:rootNode.rightNode];
    return rootNode;
}

/**
 先序遍历（递归方式）

 @param rootNode <#rootNode description#>
 @return <#return value description#>
 */
- (BOOL)preOrderTraverse:(Node *)rootNode {
    if ([self printNodeValue:rootNode]) {
        if ([self preOrderTraverse:rootNode.leftNode]) {
            if ([self preOrderTraverse:rootNode.rightNode]) {
                return YES;
            }
        }
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)inOrderTraverse:(Node *)rootNode {
    if (rootNode) {
        if ([self inOrderTraverse:rootNode.leftNode]) {
            if ([self printNodeValue:rootNode]) {
                if ([self inOrderTraverse:rootNode.rightNode]) {
                    return YES;
                }
            }
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (BOOL)postOrderTraverse:(Node *)rootNode {
    if (rootNode) {
        if ([self postOrderTraverse:rootNode.rightNode]) {
            if ([self postOrderTraverse:rootNode.leftNode]) {
                if ([self printNodeValue:rootNode]) {
                    return YES;
                }
            }
        }
        return NO;
    } else {
        return YES;
    }
    return NO;
}

- (void)breadthFirstSearch:(Node *)rootNode {
    if (!rootNode) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:rootNode];
    while (array.count > 0) {
        Node *node = array.firstObject;
        NSLog(@"bfs node's value is %ld", node.value);
        [array removeObjectAtIndex:0];
        if (node.leftNode) {
            [array addObject:node.leftNode];
        }
        if (node.rightNode) {
            [array addObject:node.rightNode];
        }
    }
}

- (BOOL)printNodeValue:(Node *)node {
    if (node) {
        NSLog(@"node's value is %ld", node.value);
        return YES;
    }
    return NO;
}

@end
