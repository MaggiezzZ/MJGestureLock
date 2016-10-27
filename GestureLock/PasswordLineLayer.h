//
//  PasswordLineLayer.h
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PasswordLineLayer : CALayer
@property (nonatomic,strong)NSArray *pointIds;
@property (nonatomic)CGPoint nowPoint;
@end
