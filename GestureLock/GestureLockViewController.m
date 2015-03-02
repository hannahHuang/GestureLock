//
//  GestureLockViewController.m
//  GestureLock
//
//  Created by hannah on 15/2/16.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import "GestureLockViewController.h"

@interface GestureLockViewController ()

@end

@implementation GestureLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.lockView.normalGestureNodesImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.lockView.selectGestureNOdesImage = [UIImage imageNamed:@"gesture_node_selected"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.contentInserts = UIEdgeInsetsMake(70, 20, 100, 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPassCode:(NSString *)code
{
    NSLog(@"%@  == ",code);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:code forKey:@"hannah"];
    NSLog(@"=== == %@",[userDefaults valueForKey:@"hannah"]);
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPassCode:(NSString *)code
{
    NSLog(@"%@",code);
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPassCode:(NSString *)code
{
    NSLog(@"%@",code);
}

@end
