//
//  LockViewController.h
//  GestureLock
//
//  Created by hannah on 15/3/2.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureLockView.h"

@interface LockViewController : UIViewController<GestureLockViewDelegate>

@property (strong, nonatomic) IBOutlet GestureLockView *lockView;

@end
