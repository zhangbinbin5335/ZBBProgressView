//
//  GradientCircleView.h
//  ZBBProgressView
//
//  Created by 张彬彬 on 2017/6/6.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWithRGBA(rgbValue, alpha1) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:alpha1]

#define UIColorWithRGB(rgb) UIColorWithRGBA(rgb, 1.0)

@interface GradientCircleView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) NSArray *colors; // 渐变色

- (void)setProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
