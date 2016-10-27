//
//  ViewController.m
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "ViewController.h"
#import "GestureLockViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIButton* button;
@end


//密码存储在NSUserDefaults中，若忘记密码，请删除应用重试
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"ViewControllerDidload");
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    self.button.backgroundColor = [UIColor redColor];
    [self viewRadius:_button radius:5.f];
    [self.view addSubview:self.button];
    BOOL haspwd = [GestureLockViewController hasPassword];
    [self buttonWithPassword:haspwd];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


-(void)buttonWithPassword:(BOOL)hasPassword{
    if (hasPassword) {
        //修改密码
        [self.button setTitle:@"修改密码" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //设置密码
        [self.button setTitle:@"设置密码" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(setPassword) forControlEvents:UIControlEventTouchUpInside];
    }
}

//设置密码
-(void)setPassword{
    GestureLockViewController* lockViewController = [[GestureLockViewController alloc] init];
    NSLog(@"ViewController设置密码");
    lockViewController.handleType = eHandlePasswordTypeSet;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:lockViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

//修改密码
-(void)modifyPassword{
    GestureLockViewController* lockViewController = [[GestureLockViewController alloc] init];
    NSLog(@"ViewController修改密码");
    lockViewController.handleType = eHandlePasswordTypeModify;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:lockViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewRadius:(UIView*)view radius:(CGFloat)radius{
    [view.layer setCornerRadius:radius];
    [view.layer setMasksToBounds:YES];
}
#define ViewRadius(View, Radius)                                                                                       \
\
[View.layer setCornerRadius:(Radius)];                                                                             \
[View.layer setMasksToBounds:YES]
#define ViewBorderRadius(View, Radius, Width, Color)                                                                   \
\
[View.layer setCornerRadius:(Radius)];                                                                             \
[View.layer setMasksToBounds:YES];                                                                                 \
[View.layer setBorderWidth:(Width)];                                                                               \
[View.layer setBorderColor:[Color CGColor]]


@end
