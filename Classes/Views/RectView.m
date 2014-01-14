//
//  RectView.m
//  Quartz Drawings
//
//  Created by Ultimatum on 13.01.14.
//  Copyright (c) 2014 Timur. All rights reserved.
//

#import "RectView.h"

//will add gradients today, and circle views;

@interface RectView () {
    
}

-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor;
-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor outerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context;
-(void)drawInnerShadowForPath: (UIBezierPath *)path innerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context;


-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor;
-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor lineWidth: (CGFloat)width lineDash:(const CGFloat *)pattern count:(NSInteger)count phase:(CGFloat)phase;

-(UIBezierPath *)drawRect: (CGRect)rect filledWithColor: (UIColor *)fillColor;
-(UIBezierPath *)drawRect: (CGRect)rect filledWithColor: (UIColor *)fillColor byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;


@end

@implementation RectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat roundedRectangleCornerRadius = 4;
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectInset(self.bounds, 130, 130) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(roundedRectangleCornerRadius, roundedRectangleCornerRadius)];
    [roundedRectanglePath closePath];
    
    //draw, fill, add outer shadow
    {
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 0.114 blue: 0.705 alpha: 1];
        CGSize outerShadowOffset = CGSizeMake(3.1, 3.1);
        CGFloat outerShadowBlurRadius = 10;
        UIColor* outerShadowColor = [UIColor colorWithRed: 0 green: 0.001 blue: 0.001 alpha: 1];
        
        [self drawPath: roundedRectanglePath filledWithColor: fillColor outerShadowColor: outerShadowColor shadowOffset: outerShadowOffset shadowBlurRadius: outerShadowBlurRadius inContext: context];
    }

    //add inner shadow
    {
        CGSize innerShadowOffset = CGSizeMake(0.1, 0.1);
        CGFloat innerShadowBlurRadius = 15;
        UIColor* innerShadowColor = [UIColor colorWithRed: 0.041 green: 0.001 blue: 0.001 alpha: 1];
        
        [self drawInnerShadowForPath: roundedRectanglePath innerShadowColor: innerShadowColor shadowOffset: innerShadowOffset shadowBlurRadius: innerShadowBlurRadius inContext:context];
    }
    
    //add stroke
    {
        UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0.114 alpha: 1];
        CGFloat strokeLineWidth = 2.0f;
        CGFloat strokePattern[] = {6, 3};
        NSInteger strokePatternCount = 2;
        CGFloat strokePhase = 0.0f;
        [self drawPath: roundedRectanglePath strokedWithColor: strokeColor lineWidth: strokeLineWidth lineDash: strokePattern count: strokePatternCount phase: strokePhase];
    }
    
}

#pragma mark - privates

-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor
{
    [fillColor setFill];
    [path fill];
}

-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor outerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, offset, radius, shadowColor.CGColor);
    [fillColor setFill];
    [path fill];
    CGContextRestoreGState(context);
}


-(void)drawInnerShadowForPath: (UIBezierPath *)path innerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context
{
    CGRect bounds = path.bounds;
    CGRect borderRect = CGRectInset(bounds, -radius, -radius);
    borderRect = CGRectOffset(borderRect, -offset.width, -offset.height);
    borderRect = CGRectInset(CGRectUnion(borderRect, bounds), -1, -1);
    
    UIBezierPath* negativePath = [UIBezierPath bezierPathWithRect: borderRect];
    [negativePath appendPath: path];
    negativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = offset.width + round(borderRect.size.width);
        CGFloat yOffset = offset.height;
        CGSize shadowSize = CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        
        CGContextSetShadowWithColor(context,
                                    shadowSize,
                                    radius,
                                    shadowColor.CGColor);
        
        [path addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderRect.size.width), 0);
        [negativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [negativePath fill];
    }
    CGContextRestoreGState(context);
}


-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor
{
    [strokeColor setStroke];
    [path stroke];
}

-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor lineWidth: (CGFloat)width lineDash:(const CGFloat *)pattern count:(NSInteger)count phase:(CGFloat)phase
{
    path.lineWidth = width;
    [path setLineDash: pattern count: count phase: phase];
    [self drawPath: path strokedWithColor: strokeColor];
}


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
