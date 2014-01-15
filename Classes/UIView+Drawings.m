//
//  UIView+Drawings.m
//  Quartz Drawings
//
//  Created by Ultimatum on 14.01.14.
//  Copyright (c) 2014 Timur. All rights reserved.
//

#import "UIView+Drawings.h"

@implementation UIView (Drawings)


-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor
{
    [fillColor setFill];
    [path fill];
}

-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor outerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, offset, radius, shadowColor.CGColor);
    [self drawPath: path filledWithColor: fillColor];
    CGContextRestoreGState(context);
}



-(void)drawPath:(UIBezierPath *)path linearlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace
{
    CGPoint startPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMinY(path.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMaxY(path.bounds));
    [self drawPath: path linearlyGradientedWithColors: fillColors locations: locations count: locationsCount startPoint: startPoint endPoint: endPoint inContext: context colorSpace: colorSpace];
}

-(void)drawPath:(UIBezierPath *)path linearlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount startPoint: (CGPoint)startPoint endPoint: (CGPoint)endPoint inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace
{
    NSAssert(fillColors.count == locationsCount, @"Can't draw gradient");
    
    CGPoint aStartPoint = startPoint;
    if (CGPointEqualToPoint(aStartPoint, CGPointZero)) {
        aStartPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMinY(path.bounds));
    }
    
    CGPoint aEndPoint = endPoint;
    if (CGPointEqualToPoint(aEndPoint, CGPointZero)) {
        aEndPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMaxY(path.bounds));
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)fillColors, locations);
    CGContextSaveGState(context);
    [path addClip];
    CGContextDrawLinearGradient(context, gradient, aStartPoint, aEndPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
}



-(void)drawPath:(UIBezierPath *)path circularlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace
{
    CGPoint startPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMidY(path.bounds));
    CGFloat startRadius = 0.0;
    
    CGPoint endPoint = startPoint;
    CGFloat endRadius = MAX(CGRectGetWidth(path.bounds), CGRectGetHeight(path.bounds));
    
    [self drawPath: path circularlyGradientedWithColors: fillColors locations: locations count: locationsCount startCenter: startPoint startRadius: startRadius endCenter: endPoint endRadius: endRadius inContext: context colorSpace: colorSpace];
}

-(void)drawPath:(UIBezierPath *)path circularlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount startCenter: (CGPoint)startPoint startRadius: (CGFloat)startRadius endCenter: (CGPoint)endPoint endRadius: (CGFloat)endRadius inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace;
{
    NSAssert(fillColors.count == locationsCount, @"Can't draw gradient");
    
    CGPoint aStartPoint = startPoint;
    if (CGPointEqualToPoint(aStartPoint, CGPointZero)) {
        aStartPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMinY(path.bounds));
    }
    
    CGPoint aEndPoint = endPoint;
    if (CGPointEqualToPoint(aEndPoint, CGPointZero)) {
        aEndPoint = CGPointMake(CGRectGetMidX(path.bounds), CGRectGetMaxY(path.bounds));
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)fillColors, locations);
    CGContextSaveGState(context);
    [path addClip];
    CGContextDrawRadialGradient(context, gradient, aStartPoint, startRadius, endPoint, endRadius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
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



@end
