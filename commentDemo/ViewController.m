//
//  ViewController.m
//  commentDemo
//
//  Created by lst on 16/8/16.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"
@interface ViewController ()
@property (nonatomic, strong) BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[BulletManager alloc]init];
    __weak typeof(self) weakSelf = self;

    //调用 manager 的回调属性
    self.manager.generateViewBlock = ^(BulletView *view){
        [weakSelf addBulletView:view];
    };
    UIButton *startBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//    [startBtn setBackgroundColor: [UIColor redColor]];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];

    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    startBtn.frame = CGRectMake(100, 100, 100, 40);
    [startBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton *stopBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    //    [startBtn setBackgroundColor: [UIColor redColor]];
    [stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    stopBtn.frame = CGRectMake(100, 200, 100, 40);
    [stopBtn addTarget:self action:@selector(stopClick) forControlEvents:UIControlEventTouchUpInside ];
    
    [self.view addSubview:stopBtn];

    [self.view addSubview:startBtn];
}
//点击按钮开始
-(void)clickBtn{
    [self.manager start];
}
-(void)stopClick{
    [self.manager stop];
}
//添加弹幕
-(void)addBulletView:(BulletView *)view{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 +  view.trajectory * 60, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
