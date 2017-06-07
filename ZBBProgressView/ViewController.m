//
//  ViewController.m
//  ZBBProgressView
//
//  Created by zhangbinbin on 2017/3/21.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "ViewController.h"

#import "ZBBProgressView.h"
#import "GradientCircleView.h"

CGFloat kRecordDruation = 15.;

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    GradientCircleView* progressView = [[GradientCircleView alloc]initWithFrame:CGRectMake(0,
//                                                                                           44,
//                                                                                           100,
//                                                                                           100)];
    ZBBProgressView* progressView = [ZBBProgressView zbbProgressViewWithType:ZBBProgressViewTypeCircle
                                                                    gradient:YES];
//    ZBBProgressView* progressView = [ZBBProgressView zbbProgressViewWithType:ZBBProgressViewTypeRect];
    
    progressView.frame = CGRectMake(0,
                                    44,
                                    100,
                                    100);
    [self.view addSubview:progressView];
    [progressView setProgress:0.2];
    progressView.tag = 1001;
//    progressView.backgroundColor = [UIColor whiteColor];
    progressView.progressColor = [UIColor redColor];
    progressView.strokeWidth = 5;
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(progress:)
                                   userInfo:nil
                                    repeats:YES];
    
//    UIView *testView = [[UIView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:testView];
//    
//    CAGradientLayer *_gradientLayer = [[CAGradientLayer alloc]init];
//    _gradientLayer.colors = @[(__bridge id)UIColorWithRGB(0xF98725).CGColor,
//                              (__bridge id)UIColorWithRGB(0xFBBC2F).CGColor];
//    _gradientLayer.startPoint = CGPointMake(1, 1);
//    _gradientLayer.endPoint = CGPointMake(0, 0);
//    [testView.layer addSublayer:_gradientLayer];
//    _gradientLayer.frame = testView.bounds;
}

-(void)progress:(NSTimer*)timer{
    ZBBProgressView* progressView = [self.view viewWithTag:1001];
    [progressView setProgress:0.6 animated:NO];
    return;
//    ZBBProgressView* progressView = [self.view viewWithTag:1001];
    
    if (progressView.progress >= 1) {
        [timer invalidate];
        return;
    }

    CGFloat progress = progressView.progress;
    progress += (1./kRecordDruation/kRecordDruation);
    [progressView setProgress:progress];
    
//    NSLog(@"progress = %f\n",progressView.progress);
}


@end
