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
    BOOL _needToFill;
    BOOL _needToAddInnerShadow;
    BOOL _needToAddOuterShadow;
    BOOL _needToStroke;
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
        
        _needToFill = NO;
        _needToAddOuterShadow = NO;
        _needToAddInnerShadow = YES;
        _needToStroke = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectToDraw = CGRectInset(self.bounds, 130, 130);
    
    UIBezierPath* path = Nil;

    //rounded rect path
    {
        //CGFloat roundedRectangleCornerRadius = 4;
        //[UIBezierPath bezierPathWithRoundedRect: rectToDraw byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(roundedRectangleCornerRadius, roundedRectangleCornerRadius)];
        //[path closePath];
    }
    
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
    
    
    //adding some stupid comment
    //and another one
}

#pragma mark - privates

-(UIBezierPath *)drawRect: (CGRect)rect filledWithColor: (UIColor *)fillColor byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
{
    // Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners: corners cornerRadii: cornerRadii];
    [roundedRectanglePath closePath];
    [self drawPath: roundedRectanglePath filledWithColor: fillColor];
    return roundedRectanglePath;
}


-(UIBezierPath *)drawRect: (CGRect)rect strokedWithColor: (UIColor *)strokeColor
{
    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rect];
    [rectanglePath closePath];
    [self drawPath: rectanglePath strokedWithColor: strokeColor];
    return rectanglePath;
}

-(UIBezierPath *)drawRect: (CGRect)rect filledWithColor: (UIColor *)fillColor;
{
    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rect];
    [rectanglePath closePath];
    [self drawPath: rectanglePath filledWithColor: fillColor];
    return rectanglePath;
}


@end
