//
//  GradientCircleView.m
//  ZBBProgressView
//
//  Created by 张彬彬 on 2017/6/6.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "GradientCircleView.h"

@interface GradientCircleView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation GradientCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.strokeWidth = 5;
        // background
        [self.layer addSublayer:self.backgroundLayer];
        // 渐变
        CALayer *gradientSuperLayer = [CALayer layer];
        [gradientSuperLayer addSublayer:self.gradientLayer];
        [gradientSuperLayer setMask:self.circleLayer];
        [self.layer addSublayer:gradientSuperLayer];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.frame;
    
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds),
                                    CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(frame.size.width / 2., frame.size.height / 2.) - self.strokeWidth;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                         radius:radius
                                                     startAngle:-M_PI_2 // 0为水平线
                                                       endAngle:-M_PI_2 + M_PI * 2
                                                      clockwise:YES];
    self.circleLayer.path = path.CGPath;
    self.circleLayer.lineWidth = self.strokeWidth;
    self.backgroundLayer.path = path.CGPath;
    self.backgroundLayer.lineWidth = self.strokeWidth;
    self.gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
#pragma mark -- public
-(void)setProgress:(CGFloat)progress{
    if (progress >= 1.0) {
        progress = 1.0;
    }
    self.circleLayer.strokeEnd = progress;
}
#pragma mark -- priviate

#pragma mark -- get&set
-(CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.strokeColor = [UIColor blueColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 5;
        _circleLayer.strokeEnd = 0;
        _circleLayer.lineCap = kCALineCapRound;
        
    }
    
    return _circleLayer;
}
-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc]init];
        _gradientLayer.colors = @[(__bridge id)UIColorWithRGB(0xF98725).CGColor,
                                  (__bridge id)UIColorWithRGB(0xFBBC2F).CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1); // (0,0)-->(0,1):竖直方向
    }
    
    return _gradientLayer;
}
-(CAShapeLayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer = [[CAShapeLayer alloc] init];
        _backgroundLayer.strokeColor = UIColorWithRGBA(0xFBA72C, 0.1).CGColor;
        _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
        _backgroundLayer.lineWidth = 5;
    }
    
    return _backgroundLayer;
}

//
-(CGFloat)progress{
    return self.circleLayer.strokeEnd;
}
-(void)setColors:(NSArray *)colors{
    if ([_colors isEqualToArray:colors]) {
        return;
    }
    _gradientLayer.colors = colors;
}
@end
