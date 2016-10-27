//
//  GestureLockViewController.h
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockView.h"

@interface GestureLockViewController : UIViewController

@property (nonatomic,assign) eHandlePasswordType handleType;

+(BOOL)hasPassword;

@end
