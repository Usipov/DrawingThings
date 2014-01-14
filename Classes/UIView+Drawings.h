//
//  UIView+Drawings.h
//  Quartz Drawings
//
//  Created by Ultimatum on 14.01.14.
//  Copyright (c) 2014 Timur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Drawings)

//filling and outer shading a path
-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor;
-(void)drawPath: (UIBezierPath *)path filledWithColor: (UIColor *)fillColor outerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context;

//inner shading a path
-(void)drawInnerShadowForPath: (UIBezierPath *)path innerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context;

//stroking a path
-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor;
-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor lineWidth: (CGFloat)width lineDash:(const CGFloat *)pattern count:(NSInteger)count phase:(CGFloat)phase;

@end
