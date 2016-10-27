//
//  PasswordLineLayer.m
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "LockView.h"
#import "PasswordLineLayer.h"

@implementation PasswordLineLayer

- (void)drawInContext:(CGContextRef)ctx {

  if (_pointIds.count <= 0) {
    return;
  }
  int pointId = [[_pointIds objectAtIndex:0] intValue];
  CGPoint pointCenter = [self getPointWithId:pointId];
  CGContextSetLineWidth(ctx, PathWidth);
  CGContextSetLineJoin(ctx, kCGLineJoinRound); //两条线连接处设置为圆角

  CGFloat *ColorComponents =
      (CGFloat *)CGColorGetComponents([PasswordLineColor CGColor]);
  CGContextSetRGBStrokeColor(ctx, ColorComponents[0], ColorComponents[1],
                             ColorComponents[2], ColorComponents[3]);

  CGContextMoveToPoint(ctx, pointCenter.x, pointCenter.y);

  for (int i = 1; i < [_pointIds count]; i++) {
    pointId = [[_pointIds objectAtIndex:i] intValue];
    pointCenter = [self getPointWithId:pointId];
    CGContextAddLineToPoint(ctx, pointCenter.x, pointCenter.y);
  }

  pointCenter = _nowPoint;
  CGContextAddLineToPoint(ctx, pointCenter.x, pointCenter.y);
  CGContextDrawPath(ctx, kCGPathStroke);
}

- (CGPoint)getPointWithId:(int)circleId {
  CGFloat x = PointLeftMargin + PointRadius +
              circleId % 3 * (PointRadius * 2 + PointBetweenMargin);
  CGFloat y = PointTopMargin + PointRadius +
              circleId / 3 * (PointRadius * 2 + PointBetweenMargin);
  CGPoint point = CGPointMake(x, y);
  return point;
}

@end
