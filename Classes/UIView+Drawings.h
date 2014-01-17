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

//filling with a linear gradient
-(void)drawPath:(UIBezierPath *)path linearlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace;
-(void)drawPath:(UIBezierPath *)path linearlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount startPoint: (CGPoint)startPoint endPoint: (CGPoint)endPoint inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace;

//filling with a circular gradient
-(void)drawPath:(UIBezierPath *)path circularlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace;
-(void)drawPath:(UIBezierPath *)path circularlyGradientedWithColors: (NSArray *)fillColors locations: (CGFloat *)locations count: (NSUInteger)locationsCount startCenter: (CGPoint)startPoint startRadius: (CGFloat)startRadius endCenter: (CGPoint)endPoint endRadius: (CGFloat)endRadius inContext: (CGContextRef)context colorSpace: (CGColorSpaceRef)colorSpace;

//inner shading a path
-(void)drawInnerShadowForPath: (UIBezierPath *)path innerShadowColor: (UIColor *)shadowColor shadowOffset: (CGSize)offset shadowBlurRadius: (CGFloat)radius inContext: (CGContextRef)context;

//stroking a path
-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor;
-(void)drawPath: (UIBezierPath *)path strokedWithColor: (UIColor *)strokeColor lineWidth: (CGFloat)width lineDash:(const CGFloat *)pattern count:(NSInteger)count phase:(CGFloat)phase;

@end
