//
//  BulletView.m
//  commentDemo
//
//  Created by lst on 16/8/16.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "BulletView.h"
#define Padding 10
#define PhotoHeight 30
@interface BulletView ()
@property (nonatomic, strong)  UILabel *lbComment;

@property (nonatomic, strong) UIImageView *photoImageView;
@end



@implementation BulletView

-(UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:_photoImageView];
    }
    return _photoImageView;
}


//初始化弹幕
- (instancetype)initComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        
        CGFloat width = [comment sizeWithAttributes:attr].width  ;
        
        //算出自身
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeight , 30);
        
        //外界传值
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        
        self.photoImageView.frame = CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding);
        
        self.photoImageView.layer.cornerRadius = (Padding + PhotoHeight)/2;
        self.photoImageView.layer.borderColor = [UIColor greenColor].CGColor;
        self.photoImageView.layer.borderWidth = 1;
        self.photoImageView.image = [UIImage imageNamed:@"QQ20160814-0"];
        
    }
    return self;
}

//开始动画
- (void) startAnimation{
    /**
     *  根据弹幕长度执行动画效果
        根据 v = S / t 计算公式进行计算运行速度
     */
    
    
    //计算屏幕宽度
    CGFloat scrrenWidth = [UIScreen mainScreen ].bounds.size.width;
    //运行时间
    CGFloat duration = 4.0f;
    //实际运行宽度
    CGFloat wholeWidth = scrrenWidth + CGRectGetWidth(self.bounds);
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    //t = s/v
    CGFloat speed = wholeWidth / duration;
    
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;

    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];//停止弹幕
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //弹幕开始
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(Enter);
//        }
//    });
    
    __block CGRect frame = self.frame;
    __weak typeof(self) weakSelf = self;
    
   [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       frame.origin.x -= wholeWidth;
       weakSelf.frame = frame;
   } completion:^(BOOL finished) {
       [weakSelf removeFromSuperview];
       if (weakSelf.moveStatusBlock) {
           weakSelf.moveStatusBlock(End);
       };
   }];
    
}
-(void)enterScreen{
            //弹幕开始
            if (self.moveStatusBlock) {
                self.moveStatusBlock(Enter);
            }
}
//结束动画
- (void) stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer  removeAllAnimations];
    [self removeFromSuperview];
}
//初始化 lable
- (UILabel *)lbComment
{
    if (!_lbComment) {
        _lbComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

@end
