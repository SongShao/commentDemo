//
//  BulletView.h
//  commentDemo
//
//  Created by lst on 16/8/16.
//  Copyright © 2016年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView
@property (nonatomic, assign) int trajectory; //弹道
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);//弹幕的状态回调


//初始化弹幕
- (instancetype)initComment:(NSString *)comment;

//开始动画
- (void) startAnimation;
//结束动画
- (void) stopAnimation;

@end
