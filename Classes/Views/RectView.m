//
//  RectView.m
//  Quartz Drawings
//
//  Created by Ultimatum on 13.01.14.
//  Copyright (c) 2014 Timur. All rights reserved.
//

#import "RectView.h"

@interface RectView () {
    BOOL _drawFill;
    BOOL _drawFillInnerShadow;
    BOOL _drawFillOuterShadow;
    BOOL _drawStroke; 
}

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
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
