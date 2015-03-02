//
//  LockViewController.m
//  GestureLock
//
//  Created by hannah on 15/3/2.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import "LockViewController.h"


@interface LockViewController ()

@end

@implementation LockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.lockView.normalGestureNodesImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.lockView.selectGestureNOdesImage = [UIImage imageNamed:@"gesture_node_selected"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.contentInserts = UIEdgeInsetsMake(70, 20, 100, 20);
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPassCode:(NSString *)code
{
    NSLog(@"%@",code);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"hannah"] isEqualToString:code]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES
                         completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPassCode:(NSString *)code
{
  
}

-(void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPassCode:(NSString *)code
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
