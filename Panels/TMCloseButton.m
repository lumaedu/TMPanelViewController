//
//  TMCloseButton.m
//  TutorMe
//
//  Created by Emerson Malca on 4/2/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "TMCloseButton.h"

@implementation TMCloseButton

@synthesize color=_color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //We need to use a slightly smaller rect because the stroke is drawn from the center of the line
    //We also need to take the shadow into account
    CGFloat borderWidth = 2.0;
    CGFloat lineWidth = 4.0;
    CGFloat shadowBlur = 2.0;
    CGFloat rectOffset = shadowBlur + borderWidth/2;
    CGRect rectangle = CGRectInset(rect, rectOffset, rectOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, borderWidth);
    
    if (_color) {
        CGContextSetFillColorWithColor(context, _color.CGColor); 
    } else {
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor); 
    }
    
    CGSize myShadowOffset = CGSizeMake (0.0, 2.0);
    CGContextSetShadowWithColor(context, myShadowOffset, shadowBlur, [UIColor darkGrayColor].CGColor);
    CGContextFillEllipseInRect(context, rectangle);
    
    CGContextSetShadowWithColor(context, myShadowOffset, shadowBlur, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeEllipseInRect(context, rectangle);
    
    //To draw the cross in the center we use a smaller rectangle to make it easier
    CGFloat rectInset = 9.0;
    CGRect crossRect = CGRectInset(rectangle, rectInset, rectInset);
    //CGContextSetLineJoin(context, kCGLineJoinRound);
    //CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetLineWidth(context, lineWidth);
    
    //Drawing "\"
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(crossRect), CGRectGetMinY(crossRect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(crossRect), CGRectGetMaxY(crossRect));
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    //Drawing "/"
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMaxX(crossRect), CGRectGetMinY(crossRect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(crossRect), CGRectGetMaxY(crossRect));
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
}

@end
