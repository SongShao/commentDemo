//
//  BulletManager.h
//  commentDemo
//
//  Created by lst on 16/8/16.
//  Copyright © 2016年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

@property (nonatomic, strong) void(^generateViewBlock)(BulletView *view);


//弹幕开始执行
- (void)start;
//弹幕停止执行
- (void)stop;
@end
