//
//  PasswordPointLayer.m
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "PasswordPointLayer.h"
#import "LockView.h"

@implementation PasswordPointLayer
- (void)drawInContext:(CGContextRef)ctx
{
    CGRect pointFrame = self.bounds;
    
    
    UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(PointBorderWidth, PointBorderWidth, pointFrame.size.width-2*PointBorderWidth, pointFrame.size.height-2*PointBorderWidth)
                                                         cornerRadius:pointFrame.size.height / 2.0];
    
    UIBezierPath *smallPointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pointFrame.size.width/2.0-SmallPointRadius, pointFrame.size.width/2.0-SmallPointRadius, 2*SmallPointRadius, 2*SmallPointRadius)
                                                              cornerRadius:SmallPointRadius];
    
    if (self.highlighted)
    {
        CGContextSetFillColorWithColor(ctx, PasswordPointHighlightColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, PasswordPointBorderHighlightColor.CGColor);
        CGContextSetLineWidth(ctx, PointBorderWidth);
        CGContextAddPath(ctx, pointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGContextSetFillColorWithColor(ctx, PasswordSmallPointHighlightColor.CGColor);
        CGContextAddPath(ctx, smallPointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    else{
        CGContextSetFillColorWithColor(ctx, PasswordPointColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, PasswordPointBorderColor.CGColor);
        CGContextSetLineWidth(ctx, PointBorderWidth);
        CGContextAddPath(ctx, pointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGContextSetFillColorWithColor(ctx, PasswordSmallPointColor.CGColor);
        CGContextAddPath(ctx, smallPointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    
}

@end
