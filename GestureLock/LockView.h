//
//  LockView.h
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordLineLayer.h"
#import "PasswordPointLayer.h"

//适配 iPhone6为基准
#define AdaptX(x) [UIScreen mainScreen].bounds.size.width / 375 * x
#define AdaptY(y) [UIScreen mainScreen].bounds.size.height / 667 * y
#define PointRadius AdaptX(35.0)//圆半径
#define PointBorderWidth AdaptX(1.0)//圆边框宽
#define SmallPointRadius AdaptX(6.0)//小圆半径
#define PointLeftMargin AdaptX(42.5)//起始margin
#define PointTopMargin AdaptY(25.0)//起始margin
#define PointBetweenMargin AdaptX(40.0)//间隔*2
#define PathWidth AdaptX(12.0)//线宽
#define PasswordMinLength 4//最短密码

#define PasswordPointColor [UIColor clearColor]//圆颜色
//#define PasswordPointColor [UIColor colorWithRed:50.0/255.0 green:200.0/255.0 blue:50.0/255.0 alpha:0.4]//圆颜色

#define PasswordPointBorderColor [UIColor grayColor]//圆框颜色
//#define PasswordSmallPointColor [UIColor colorWithRed:50.0/255.0 green:145/255.0 blue:60.0/255.0 alpha:1]//小圆颜色
#define PasswordSmallPointColor [UIColor grayColor]
#define PasswordPointHighlightColor [UIColor orangeColor]//圆高亮色
#define PasswordPointBorderHighlightColor [UIColor redColor]//圆框高亮色
#define PasswordSmallPointHighlightColor [UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1]//小圆高亮色
#define PasswordLineColor [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4]//线颜色

typedef enum eHandlePasswordType {
    eHandlePasswordTypeSet = 0,//设置
    eHandlePasswordTypeModify,//修改密码
    eHandlePasswordTypeVerify//验证密码
}eHandlePasswordType;
@class LockView;
@protocol PasswordViewDelegate <NSObject>
#pragma mark - 输入完回掉
- (void)PasswordView:(LockView *)passwordView withMessage:(NSString*)password andWarning:(BOOL)showWarning;

//
- (void)dismissCurrentVC;
@end
@interface LockView : UIView

//@property (nonatomic,weak) id<PasswordViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray* pointArr;
@property (nonatomic,strong) PasswordLineLayer *pathLayer;
@property (nonatomic,weak) id<PasswordViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *pointIDArr;//当前已输的密码
@property(nonatomic)CGPoint nowTouchPoint;//当前位置
- (id)initWithFrame:(CGRect)frame andHandleType:(eHandlePasswordType)handleType;
+(BOOL)hasPassword;

@end

