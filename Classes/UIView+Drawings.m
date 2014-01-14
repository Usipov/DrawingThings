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



@end
