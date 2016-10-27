//
//  LockView.m
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CoreArchive.h"
#import "LockView.h"

@interface LockView ()
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, assign) eHandlePasswordType handleType;
@property(nonatomic, strong) NSMutableArray *setPasswordArray;
@property(nonatomic, assign) int wrongPwdCount;
@end

@implementation LockView

- (id)initWithFrame:(CGRect)frame
      andHandleType:(eHandlePasswordType)handleType {
  self = [super initWithFrame:frame];
  if (self) {
    self.wrongPwdCount = 0;
    self.handleType = handleType;
    self.setPasswordArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor whiteColor];

    _pointArr = [NSMutableArray arrayWithCapacity:9];
    _pointIDArr = [NSMutableArray arrayWithCapacity:9];
    PasswordPointLayer *pointLayer;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        pointLayer = [PasswordPointLayer layer];
        [_pointArr addObject:pointLayer];
        [self.layer addSublayer:pointLayer];
        [pointLayer setNeedsDisplay];
      }
    }
    _pathLayer = [PasswordLineLayer layer];
    [self.layer addSublayer:_pathLayer];
    [self setLayerFrames];
  }
  return self;
}

+ (BOOL)hasPassword {
  NSString *pwd = [CoreArchive strForKey:@"password"];
  return pwd != nil;
}

- (void)setLayerFrames {
  CGPoint point;
  PasswordPointLayer *pointLayer;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      CGFloat x = PointLeftMargin + PointRadius +
                  j * (PointRadius * 2 + PointBetweenMargin);
      CGFloat y = PointTopMargin + PointRadius +
                  i * (PointRadius * 2 + PointBetweenMargin);
      point = CGPointMake(x, y);
      pointLayer = [_pointArr objectAtIndex:i * 3 + j];
      pointLayer.frame = CGRectMake(x - PointRadius, y - PointRadius,
                                    PointRadius * 2, PointRadius * 2);
      [pointLayer setNeedsDisplay];
    }
  }
  _pathLayer.frame = self.bounds;
  [_pathLayer setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  UITouch *touch = [touches anyObject];
  _nowTouchPoint = [touch locationInView:self];

  PasswordPointLayer *pointLayer;
  for (int i = 0; i < 9; i++) {
    pointLayer = [self.pointArr objectAtIndex:i];
    if ([self containPoint:_nowTouchPoint inCircle:pointLayer.frame]) {
      pointLayer.highlighted = YES;
      [pointLayer setNeedsDisplay];
      break;
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  UITouch *touch = [touches anyObject];
  self.nowTouchPoint = [touch locationInView:self];
  PasswordPointLayer *pointLayer;
  for (int i = 0; i < 9; i++) {
    pointLayer = [self.pointArr objectAtIndex:i];
    if ([self containPoint:_nowTouchPoint inCircle:pointLayer.frame]) {
      if (![self hasVistedPoint:i]) {
        pointLayer.highlighted = YES;
        [pointLayer setNeedsDisplay];
        [self.pointIDArr addObject:[NSNumber numberWithInt:i]];
        break;
      }
    }
  }
  _pathLayer.pointIds = _pointIDArr;
  _pathLayer.nowPoint = _nowTouchPoint;
  [_pathLayer setNeedsDisplay];
}

#pragma-- mark touchesEnded

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  NSString *password = [self getPassword:_pointIDArr];
  //设置密码
  if (self.handleType == eHandlePasswordTypeSet) {
    [self settingPasswordWithPassword:password];
    //修改密码
  } else {
    [self modifyPasswordWithPasswrod:password];
  }

  [self finishSelectPointAndLine];
}

- (void)settingPasswordWithPassword:(NSString *)password {

  [self.setPasswordArray addObject:password];

  //第一次绘制
  if (self.setPasswordArray.count == 1) {
    //请确认绘制
    if (password.length < PasswordMinLength) {
      [self.delegate PasswordView:self
                      withMessage:@"至少4个点，请重新绘制"
                       andWarning:YES];
      [self.setPasswordArray removeLastObject];
    } else {
      [self.delegate PasswordView:self
                      withMessage:@"再次绘制解锁图案"
                       andWarning:NO];
    }

    //第二次绘制
  } else if (self.setPasswordArray.count == 2) {
    //回调
    NSLog(@"第二次绘制");
    if ([self.setPasswordArray[0] isEqualToString:self.setPasswordArray[1]]) {

      [CoreArchive setStr:password key:@"password"];
      [self.delegate dismissCurrentVC];

    } else {

      [self.delegate PasswordView:self
                      withMessage:@"与上次绘制不符，请重新绘制"
                       andWarning:YES];
      [self.setPasswordArray removeLastObject];
    }
  }
}

- (void)modifyPasswordWithPasswrod:(NSString *)password {

  NSLog(@"修改密码!!!");
  NSString *savedPassword = [CoreArchive strForKey:@"password"];

  if ([password isEqualToString:savedPassword]) {
    self.handleType = eHandlePasswordTypeSet;
    [self.delegate PasswordView:self
                    withMessage:@"密码正确，请绘制新图案"
                     andWarning:NO];
    NSLog(@"密码正确，返回");
  } else {
    NSLog(@"密码不正确，请重新输入");
    self.wrongPwdCount += 1;
    int leftTimes = 5 - self.wrongPwdCount;
    if (leftTimes == 0) {

      [self.delegate dismissCurrentVC];

    } else {
      [self.delegate
          PasswordView:self
           withMessage:[NSString stringWithFormat:
                                     @"密码错误，还可以输入%d次",
                                     leftTimes]
            andWarning:YES];
    }
  }
}

- (void)finishSelectPointAndLine {
  // 9个密码点的选中色取消
  PasswordPointLayer *pointLayer;
  for (int i = 0; i < 9; i++) {
    pointLayer = [self.pointArr objectAtIndex:i];
    if (pointLayer.highlighted == YES) {
      pointLayer.highlighted = NO;
      [pointLayer setNeedsDisplay];
    }
  }
  [self.pointIDArr removeAllObjects];
  [self.pathLayer setNeedsDisplay];
}

- (BOOL)containPoint:(CGPoint)point inCircle:(CGRect)rect {
  CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2,
                               rect.origin.y + rect.size.height / 2);
  BOOL isContain = ((center.x - point.x) * (center.x - point.x) +
                    (center.y - point.y) * (center.y - point.y) -
                    PointRadius * PointRadius) < 0;
  return isContain;
}

- (BOOL)hasVistedPoint:(int)pointId {
  BOOL hasVisit = NO;
  for (NSNumber *number in _pointIDArr) {
    if ([number intValue] == pointId) {
      hasVisit = YES;
      break;
    }
  }
  return hasVisit;
}

- (NSString *)getPassword:(NSArray *)array {
  NSMutableString *password = [[NSMutableString alloc] initWithCapacity:9];
  for (int i = 0; i < [array count]; i++) {
    NSNumber *number = [array objectAtIndex:i];
    [password appendFormat:@"%d", [number intValue]];
  }
  return password;
}

@end
