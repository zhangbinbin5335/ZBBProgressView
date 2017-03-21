//
//  ViewController.m
//  ZBBProgressView
//
//  Created by zhangbinbin on 2017/3/21.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "ViewController.h"

#import "ZBBProgressView.h"

CGFloat kRecordDruation = 15.;

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    ZBBProgressView* progressView = [ZBBProgressView zbbProgressViewWithType:ZBBProgressViewTypeCircle];
//    ZBBProgressView* progressView = [ZBBProgressView zbbProgressViewWithType:ZBBProgressViewTypeArc];
//    ZBBProgressView* progressView = [ZBBProgressView zbbProgressViewWithType:ZBBProgressViewTypeRect];
    
    progressView.frame = CGRectMake(0,
                                    44,
                                    self.view.bounds.size.width,
                                    60);
    [self.view addSubview:progressView];
//    [progressView setProgress:0.2 animated:NO];
    progressView.tag = 1001;
    progressView.backgroundColor = [UIColor yellowColor];
    progressView.progressColor = [UIColor redColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1./ kRecordDruation
                                     target:self
                                   selector:@selector(progress:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)progress:(NSTimer*)timer{
    ZBBProgressView* progressView = [self.view viewWithTag:1001];
    
    if (progressView.progress >= 1) {
        [timer invalidate];
        return;
    }

    CGFloat progress = progressView.progress;
    progress += (1./kRecordDruation/kRecordDruation);
    [progressView setProgress:progress animated:NO];
    
//    NSLog(@"progress = %f\n",progressView.progress);
}


@end
