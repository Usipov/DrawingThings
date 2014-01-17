//
//  RectView.m
//  Quartz Drawings
//
//  Created by Ultimatum on 13.01.14.
//  Copyright (c) 2014 Timur. All rights reserved.
//

#import "ExampleView.h"
#import "UIView+Drawings.h"

@interface ExampleView () {

}

@end

@implementation ExampleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = NO;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect rectToDrawIn = CGRectInset(self.bounds, 20, 20);
    
    //get a path
    UIBezierPath* path = [self rectPathInRect: rectToDrawIn];
    //UIBezierPath* path = [self circlePathInRect: rectToDraw];
    
<<<<<<< HEAD
    //circle path
    {
        
        //path = [UIBezierPath bezierPathWithOvalInRect: rectToDraw];
        
        CGFloat circleRadius = 0.5 * MIN(CGRectGetWidth(rectToDraw), CGRectGetHeight(rectToDraw));

        path = [UIBezierPath bezierPath];
        [path addArcWithCenter: CGPointMake(0, 0) radius: circleRadius startAngle: 120 * M_PI/180 endAngle: 350 * M_PI/180 clockwise: YES];
        [path addLineToPoint: CGPointMake(0, 0)];
        [path closePath];
        
        CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(rectToDraw), CGRectGetMidY(rectToDraw));
        ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(rectToDraw) / CGRectGetWidth(rectToDraw));
        [path applyTransform: ovalTransform];
    }

    
    
    //draw, fill, add outer shadow
    if (_needToFill)
    {
        UIColor* fillColor = [UIColor colorWithRed: 0.531 green: 0.114 blue: 0.705 alpha: 1];
        CGSize outerShadowOffset = CGSizeMake(3.1, 3.1);
        CGFloat outerShadowBlurRadius = 10;
        UIColor* outerShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
        if (! _needToAddOuterShadow) {
            [self drawPath: path filledWithColor: fillColor];
        } else {
            [self drawPath: path filledWithColor: fillColor outerShadowColor: outerShadowColor shadowOffset: outerShadowOffset shadowBlurRadius: outerShadowBlurRadius inContext: context];
        }
    }

    //add inner shadow
    if (_needToAddInnerShadow)
    {
        CGSize innerShadowOffset = CGSizeMake(0.1, 0.1);
        CGFloat innerShadowBlurRadius = 15;
        UIColor* innerShadowColor = [UIColor colorWithRed: 0.041 green: 0.001 blue: 0.001 alpha: 1];
        
        [self drawInnerShadowForPath: path innerShadowColor: innerShadowColor shadowOffset: innerShadowOffset shadowBlurRadius: innerShadowBlurRadius inContext:context];
    }
    
    //add stroke
    if (_needToStroke)
    {
        UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0.114 alpha: 1];
        CGFloat strokeLineWidth = 2.0f;
        CGFloat strokePattern[] = {6, 3};
        NSInteger strokePatternCount = 2;
        CGFloat strokePhase = 0.0f;
        [self drawPath: path strokedWithColor: strokeColor lineWidth: strokeLineWidth lineDash: strokePattern count: strokePatternCount phase: strokePhase];
    }
=======
    
    //draw
    //[self fillPath: path];
    //[self fillAndOuterShadePath: path];
    //[self fillWithLinearGraidentPath: path];
    [self fillWIthCircularGradientPath: path];
    
    [self innerShadePath: path];
    [self strokePath: path];
    
>>>>>>> update-branch
}

#pragma mark - paths

-(UIBezierPath *)rectPathInRect: (CGRect)rect
{
    CGFloat roundedRectangleCornerRadius = 20;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(roundedRectangleCornerRadius, roundedRectangleCornerRadius)];
    [path closePath];
    return path;
}

-(UIBezierPath *)circlePathInRect: (CGRect)rect
{
    CGFloat circleRadius = 0.5 * MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter: CGPointMake(0, 0) radius: circleRadius startAngle: 120 * M_PI/180 endAngle: 350 * M_PI/180 clockwise: YES];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path closePath];

    CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(rect), CGRectGetMidY(rect));
    ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(rect) / CGRectGetWidth(rect));
    [path applyTransform: ovalTransform];

    return path;
}

#pragma nark - drawing tests

-(void)fillPath: (UIBezierPath *)path
{
    UIColor* fillColor = [UIColor colorWithRed: 0.531 green: 0.114 blue: 0.705 alpha: 1];
    [self drawPath: path filledWithColor: fillColor];
}

-(void)fillAndOuterShadePath: (UIBezierPath *)path
{
    UIColor* fillColor = [UIColor colorWithRed: 0.531 green: 0.114 blue: 0.705 alpha: 1];
    CGSize outerShadowOffset = CGSizeMake(3.1, 3.1);
    CGFloat outerShadowBlurRadius = 10;
    UIColor* outerShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    [self drawPath: path filledWithColor: fillColor outerShadowColor: outerShadowColor shadowOffset: outerShadowOffset shadowBlurRadius: outerShadowBlurRadius inContext: UIGraphicsGetCurrentContext()];
}

-(void)fillWithLinearGraidentPath: (UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor whiteColor].CGColor];
    [self drawPath: path linearlyGradientedWithColors: colors locations: locations count: 2 inContext: context colorSpace: colorSpace];
    //[self drawPath: path linearlyGradientedWithColors: colors locations: locations count: 3 startPoint: CGPointMake(100, 100) endPoint: CGPointMake(120, 400) inContext: context colorSpace: colorSpace];
    
    CGColorSpaceRelease(colorSpace);
}

-(void)fillWIthCircularGradientPath: (UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = {0.0, 0.5, 1.0};
    NSArray *colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent: 0.2].CGColor, (id)[[UIColor blackColor] colorWithAlphaComponent: 0.2].CGColor];
    [self drawPath: path circularlyGradientedWithColors: colors locations: locations count: 2 inContext: context colorSpace: colorSpace];
    //[self drawPath: path circularlyGradientedWithColors: colors locations: locations count: 2  startCenter: CGPointMake(100, 120) startRadius: 20 endCenter: CGPointMake(231, 83) endRadius: 400 inContext: context colorSpace: colorSpace];
    
    CGColorSpaceRelease(colorSpace);
}

-(void)innerShadePath: (UIBezierPath *)path
{
    CGSize innerShadowOffset = CGSizeMake(0.1, 0.1);
    CGFloat innerShadowBlurRadius = 15;
    UIColor* innerShadowColor = [UIColor colorWithRed: 0.041 green: 0.001 blue: 0.001 alpha: 1];
    
    [self drawInnerShadowForPath: path innerShadowColor: innerShadowColor shadowOffset: innerShadowOffset shadowBlurRadius: innerShadowBlurRadius inContext: UIGraphicsGetCurrentContext()];
}

-(void)strokePath: (UIBezierPath *)path
{
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0.114 alpha: 1];
    CGFloat strokeLineWidth = 2.0f;
    CGFloat strokePattern[] = {6, 3};
    NSInteger strokePatternCount = 2;
    CGFloat strokePhase = 0.0f;
    [self drawPath: path strokedWithColor: strokeColor lineWidth: strokeLineWidth lineDash: strokePattern count: strokePatternCount phase: strokePhase];
}

@end
