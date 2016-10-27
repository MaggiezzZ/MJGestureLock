//
//  GestureLockViewController.m
//  GestureLock
//
//  Created by ymj_work on 16/6/15.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "GestureLockViewController.h"

@interface GestureLockViewController ()<PasswordViewDelegate>
@property (nonatomic,strong) LockView* lockView;
@property (nonatomic,strong) UILabel* infoLabel;
@end

@implementation GestureLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCurrentVC)];
    [self setFrame];
    
    // Do any additional setup after loading the view.
}


-(void)setFrame{
    //绘制密码9个按钮
    _lockView = [[LockView alloc] initWithFrame:CGRectMake(30, 240, 350, 350) andHandleType:self.handleType];
    _lockView.delegate = self;
    [self.view addSubview:self.lockView];
    
    //状态提示标签
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, self.view.frame.size.width-80, 60)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    if (self.handleType == eHandlePasswordTypeSet) {
        _infoLabel.text = @"请绘制解锁图案";

    }else if (self.handleType == eHandlePasswordTypeModify){
        _infoLabel.text = @"请输入原手势密码";
    }
    
    _infoLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.infoLabel];
}


+(BOOL)hasPassword{
    BOOL hasPwd = [LockView hasPassword];
    return hasPwd;
}

#pragma mark - PasswordViewDelegate
- (void)PasswordView:(LockView *)passwordView withMessage:(NSString*)password andWarning:(BOOL)showWarning{
    _infoLabel.text = password;
    if (showWarning) {
        _infoLabel.textColor = [UIColor redColor];
        [self labelShakeAnimation:self.infoLabel];
    }else{
        _infoLabel.textColor = [UIColor blackColor];
    }
}

-(void)dismissCurrentVC{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)labelShakeAnimation:(UILabel*)label{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat s = 16;
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    kfa.duration = .1f;//时长
    kfa.repeatCount = 1;//重复
    kfa.removedOnCompletion = YES;//移除
    [label.layer addAnimation:kfa forKey:@"shake"];
}


@end
