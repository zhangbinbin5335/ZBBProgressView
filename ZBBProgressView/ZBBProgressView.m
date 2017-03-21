//
//  ZBBProgressView.m
//  ZBBProgressView
//
//  Created by zhangbinbin on 2017/3/21.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "ZBBProgressView.h"

CGFloat kAnimationDurationTime = 0.25;

@interface ZBBProgressLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat progress;

@end

@implementation ZBBProgressLayer

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"progress"]/*progress 属性变化时，重绘*/) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)dealloc{
    [self removeAllAnimations];
}

@end

// ZBBRectProgressLayer
@interface ZBBRectProgressLayer : ZBBProgressLayer

@end

@implementation ZBBRectProgressLayer

-(void)drawInContext:(CGContextRef)ctx{
    
    CGSize boundsSize = self.bounds.size;
    CGFloat width = boundsSize.width * self.progress;
    
    UIBezierPath *cutoutPath =[UIBezierPath bezierPathWithRect:CGRectMake(0,
                                                                          0,
                                                                          width,
                                                                          boundsSize.height)];
    
    
    CGContextSetFillColorWithColor(ctx,self.fillColor);
    CGContextAddPath(ctx, cutoutPath.CGPath);
    CGContextFillPath(ctx);
//    NSLog(@"%@ = %@\n",[self class],self);
}

@end

// ZBBArcProgressLayer
@interface ZBBArcProgressLayer : ZBBProgressLayer

@end

@implementation ZBBArcProgressLayer

-(void)drawInContext:(CGContextRef)ctx{
    
    CGSize boundsSize = self.bounds.size;
    CGFloat radius = MIN(boundsSize.width/2., boundsSize.height/2.);
    
    //
    UIBezierPath *circlePath =[UIBezierPath bezierPathWithArcCenter:self.position
                                                                radius:radius
                                                            startAngle:0
                                                            endAngle:2 * M_PI
                                                            clockwise:YES];
    
    
    CGContextSetStrokeColorWithColor(ctx,[UIColor blueColor].CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextStrokePath(ctx);
    
    CGFloat startAngle = -M_PI_2; // 0为水平线
    CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
    CGPoint center = CGPointMake(boundsSize.width / 2., boundsSize.height / 2.);
    
    UIBezierPath *cutoutPath =[UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius - 2
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    
    //  从弧线结束为止绘制一条线段到圆心。这样系统会自动闭合图形，绘制一条从圆心到弧线起点的线段。
    [cutoutPath addLineToPoint:center];
    
    CGContextSetFillColorWithColor(ctx,self.fillColor);
    CGContextAddPath(ctx, cutoutPath.CGPath);
    CGContextFillPath(ctx);
}

@end

// ZBBCircleProgressLayer
@interface ZBBCircleProgressLayer : ZBBProgressLayer

@end

@implementation ZBBCircleProgressLayer

-(void)drawInContext:(CGContextRef)ctx{
    
    CGSize boundsSize = self.bounds.size;
    CGFloat radius = MIN(boundsSize.width/2., boundsSize.height/2.);
    
    CGFloat startAngle = -M_PI_2; // 0为水平线
    CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
    CGPoint center = CGPointMake(boundsSize.width / 2., boundsSize.height / 2.);
    
    UIBezierPath *cutoutPath =[UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    
    CGContextSetStrokeColorWithColor(ctx,self.fillColor);
    CGContextAddPath(ctx, cutoutPath.CGPath);
    CGContextStrokePath(ctx);
}

@end

@interface ZBBProgressView ()

@property (nonatomic, strong) ZBBProgressLayer* maskLayer; //

@end

@implementation ZBBProgressView

#pragma mark -- life cycle
+(instancetype)zbbProgressViewWithType:(ZBBProgressViewType)type{
    ZBBProgressView* progressView = [[ZBBProgressView alloc]init];
    
    switch (type) {
        case ZBBProgressViewTypeArc:
            progressView.maskLayer = [[ZBBArcProgressLayer alloc]init];
            break;
            
        case ZBBProgressViewTypeRect:
        progressView.maskLayer = [[ZBBRectProgressLayer alloc]init];
        break;
        
        case ZBBProgressViewTypeCircle:
        progressView.maskLayer = [[ZBBCircleProgressLayer alloc]init];
        break;
            
        default:
            break;
    }
    
    return progressView;
}

-(void)dealloc{
    
    NSLog(@"%@ dealloc",[self class]);
}

#pragma mark -- public
-(void)setMaskLayer:(ZBBProgressLayer *)maskLayer{
    if (maskLayer && _maskLayer != maskLayer) {
        _maskLayer = maskLayer;
        [self.layer addSublayer:maskLayer];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (_maskLayer) {
        _maskLayer.frame = self.layer.bounds;
    }
}

-(void)setProgress:(CGFloat)progress{
    [self setProgress:progress animated:YES];
}

-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    _maskLayer.fillColor = _progressColor.CGColor;
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    _progress = MIN(progress, 1);
    if (animated) {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        
        animation.duration = kAnimationDurationTime;
        animation.fromValue = @(_maskLayer.progress);
        animation.toValue = @(_progress);
        
        [_maskLayer addAnimation:animation forKey:@"progress"];
        _maskLayer.progress = _progress;
    }else{
        _maskLayer.progress = _progress;
        [_maskLayer performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
    }
}

@end
