//
//  ZBBProgressView.m
//  ZBBProgressView
//
//  Created by zhangbinbin on 2017/3/21.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "ZBBProgressView.h"

#define UIColorWithRGBA(rgbValue, alpha1) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:alpha1]

#define UIColorWithRGB(rgb) UIColorWithRGBA(rgb, 1.0)

static CGFloat kAnimationDurationTime = 0.25;

@interface ZBBProgressLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat progress;
@property(nullable) CGColorRef progressColor;

@end

@implementation ZBBProgressLayer
/**
 *  CALayer在运行时对这个radius自动生成了set和get方法,
 *  并且这些存取方法有重要的逻辑,关键是不要在CALayer中实现自定义的存取方法或是使用@synthesize
 *  @dynamic就是告诉编译器,不自动生成setter和getter方法
 */
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
    
    
    CGContextSetFillColorWithColor(ctx,self.progressColor);
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
                                                                radius:radius - self.lineWidth
                                                            startAngle:0
                                                            endAngle:2 * M_PI
                                                            clockwise:YES];
    
    
    CGContextSetStrokeColorWithColor(ctx,self.progressColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextStrokePath(ctx);
    
    CGFloat startAngle = -M_PI_2; // 0为水平线
    CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
    CGPoint center = CGPointMake(boundsSize.width / 2., boundsSize.height / 2.);
    
    UIBezierPath *cutoutPath =[UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius - 2 - self.lineWidth
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    
    //  从弧线结束为止绘制一条线段到圆心。这样系统会自动闭合图形，绘制一条从圆心到弧线起点的线段。
    [cutoutPath addLineToPoint:center];
    
    CGContextSetFillColorWithColor(ctx,self.progressColor);
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
                                                             radius:radius - self.lineWidth
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    CGContextSetStrokeColorWithColor(ctx,self.progressColor);
    CGContextAddPath(ctx, cutoutPath.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextStrokePath(ctx);
}

@end

@interface ZBBProgressView ()

@property (nonatomic, strong) ZBBProgressLayer* maskLayer; //
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变

@end

@implementation ZBBProgressView

#pragma mark -- life cycle
+(instancetype)zbbProgressViewWithType:(ZBBProgressViewType)type{
    
    return [self zbbProgressViewWithType:type gradient:NO];
}

+(instancetype)zbbProgressViewWithType:(ZBBProgressViewType)type gradient:(BOOL)gradient{
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

    if (gradient) {
        [progressView.layer addSublayer:progressView.gradientLayer];
        [progressView.layer setMask:progressView.maskLayer];
    }else{
        [progressView.layer addSublayer:progressView.maskLayer];
    }
    return progressView;
}

-(void)dealloc{
    
    NSLog(@"%@ dealloc",[self class]);
}
#pragma mark -- overwrite
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (_maskLayer) {
        _maskLayer.frame = self.layer.bounds;
        _gradientLayer.frame = self.layer.bounds;
    }
}
#pragma mark -- get&set
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

-(void)setMaskLayer:(ZBBProgressLayer *)maskLayer{
    if (maskLayer && _maskLayer != maskLayer) {
        _maskLayer = maskLayer;
    }
}

-(void)setProgress:(CGFloat)progress{
    [self setProgress:progress animated:YES];
}

-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    _maskLayer.progressColor = _progressColor.CGColor;
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

-(void)setColors:(NSArray *)colors{
    if ([_colors isEqualToArray:colors]) {
        return;
    }
    _gradientLayer.colors = colors;
}

-(void)setStrokeWidth:(CGFloat)strokeWidth{
    _maskLayer.lineWidth = strokeWidth;
}

@end
