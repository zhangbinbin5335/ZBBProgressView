//
//  ZBBProgressView.h
//  ZBBProgressView
//
//  Created by zhangbinbin on 2017/3/21.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ZBBProgressViewType) {
    ZBBProgressViewTypeRect, // 长条形进度条
    ZBBProgressViewTypeCircle, // 圆形进度条
    ZBBProgressViewTypeArc //弧形进度条
};

@interface ZBBProgressView : UIView

+(instancetype)zbbProgressViewWithType:(ZBBProgressViewType)type; // 不要用initWithFrame

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor* progressColor;

- (void)setProgress:(CGFloat)progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
