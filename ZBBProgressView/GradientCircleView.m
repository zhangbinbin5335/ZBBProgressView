//
//  GradientCircleView.m
//  ZBBProgressView
//
//  Created by 张彬彬 on 2017/6/6.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "GradientCircleView.h"

static CGFloat kAnimationDurationTime = 0.25;

@interface CircleProgressLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *progressColor;

@end

@implementation CircleProgressLayer
@dynamic progressColor;

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"progress"]/*progress 属性变化时，重绘*/) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)dealloc{
    [self removeAllAnimations];
}

-(void)drawInContext:(CGContextRef)ctx{
    
    CGSize boundsSize = self.bounds.size;
    CGFloat radius = MIN(boundsSize.width/2., boundsSize.height/2.);
    
    CGFloat startAngle = -M_PI_2; // 0为水平线
    CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
    CGPoint center = CGPointMake(boundsSize.width / 2., boundsSize.height / 2.);
    
    UIBezierPath *cutoutPath =[UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius - self.lineWidth
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    CGContextSetStrokeColorWithColor(ctx,self.progressColor.CGColor);
    CGContextAddPath(ctx, cutoutPath.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextStrokePath(ctx);
}

@end

@interface GradientCircleView ()

@property (nonatomic, strong) CircleProgressLayer *circleLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变
@property (nonatomic, strong) CircleProgressLayer *backgroundLayer;

@end

@implementation GradientCircleView
@synthesize progress = _progress;

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
    CGRect bounds = self.bounds;
    
    self.circleLayer.frame = bounds;
    self.circleLayer.lineWidth = self.strokeWidth;
    
    self.backgroundLayer.frame = bounds;
    self.backgroundLayer.lineWidth = self.strokeWidth;
    self.backgroundLayer.progress = 1;
    [self.backgroundLayer setNeedsDisplay];
    
    self.gradientLayer.frame = bounds;
}
#pragma mark -- public
#pragma mark -- priviate

#pragma mark -- get&set
-(CircleProgressLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CircleProgressLayer alloc] init];
        _circleLayer.strokeColor = [UIColor blueColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
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
-(CircleProgressLayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer = [[CircleProgressLayer alloc] init];
        _backgroundLayer.progressColor = UIColorWithRGBA(0xFBA72C, 0.1);
    }
    
    return _backgroundLayer;
}

//
-(void)setProgress:(CGFloat)progress{
    [self setProgress:progress animated:YES];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    _progress = MIN(progress, 1);
    if (animated) {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        
        animation.duration = kAnimationDurationTime;
        animation.fromValue = @(_circleLayer.progress);
        animation.toValue = @(_progress);
        
        [_circleLayer addAnimation:animation forKey:@"progress"];
        _circleLayer.progress = _progress;
    }else{
        _circleLayer.progress = _progress;
        [_circleLayer performSelectorOnMainThread:@selector(setNeedsDisplay)
                                           withObject:nil
                                        waitUntilDone:YES];
    }
}
-(void)setColors:(NSArray *)colors{
    if ([_colors isEqualToArray:colors]) {
        return;
    }
    _gradientLayer.colors = colors;
}
@end
