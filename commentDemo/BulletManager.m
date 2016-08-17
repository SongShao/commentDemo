//
//  BulletManager.m
//  commentDemo
//
//  Created by lst on 16/8/16.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager ()
//弹幕的数据来源
@property (nonatomic, strong)  NSMutableArray *datasource;
//弹幕使用中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;
//存储弹幕 view 的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;
//给一个变量来控制
@property BOOL bStopAnimation;

@end

@implementation BulletManager

-(instancetype)init
{
    if (self == [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}


//弹幕开始执行
- (void)start;{
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    [self initBulletComment];
    
}
//初始化弹幕 ,随机分配弹幕轨迹
-(void)initBulletComment {
    //创建弹道数组
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2),@(3)]];
    NSLog(@"%lu",(unsigned long)trajectorys.count);
    for (NSInteger i = 0; i < 4; i++) {
        
        if (self.bulletComments > 0) {
            //创建一个随机数
            NSInteger index = arc4random() % trajectorys.count;
            //获取弹道
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            //将取过的弹道   清除
            [trajectorys removeObjectAtIndex:index];
            //从弹幕数组中逐一取出弹幕数组
            //取出位于数组的第一个元素
            NSString *comment = [self.bulletComments firstObject];
            //将取出过的删除掉
            [self.bulletComments removeObjectAtIndex:0];
            //创建弹幕 view
            [self creatBulletView:comment trajectory:trajectory];
            
        }
      
    }
    
}
//根据弹幕内容及弹幕轨迹创建弹幕
- (void)creatBulletView:(NSString *)commet  trajectory:(int)trajectory{
    
    if (self.bStopAnimation) {
        return;
    }
    
    
    BulletView *view = [[BulletView alloc]initComment:commet];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (weakSelf.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕,将 view 加入到弹幕管理的变量中 bulletViews
                [weakSelf.bulletViews addObject:weakView];
                break;}
            case Enter:{
                //弹幕完全进入弹幕,判断是否还有其他内容,如果有就在弹幕轨迹中创建一个弹幕
                NSString *commet = [weakSelf nextCommemt];
                if (commet) {
                    [weakSelf creatBulletView:commet trajectory:trajectory];
                }
                
                break;}
            case End:{
                //弹幕完全飞出屏幕后  需要从 bulletViews 中删除 并且释放资源
                if ([self.bulletViews containsObject:weakView]) {
                    //停止动画
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
                    //说明屏幕上没有弹幕 开始循环滚动
                    weakSelf.bStopAnimation = YES;
                    [weakSelf start];
                    
                }
                
                break;}
            default:
                break;
        }
        
        

//        
    };
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

//弹幕停止执行
- (void)stop;{
    if (self.bStopAnimation) {
        return;
    };
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
        
    }];
    
    [self.bulletViews removeAllObjects];
    
    
}
//取下一条弹幕
-(NSString *)nextCommemt {
    if (self.bulletComments == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithArray:@[@"111111111111111",
                                                       @"222",
                                                       @"33333333333333333333333333333", @"444444444444444", @"55555", @"666666666666666666666666666666666666666",@"777777777",@"8888888",@"999999",@"111111111111",@"222"]];
    }
    return _datasource;
}
-(NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}
-(NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
