//
//  GestureLockViewController.h
//  GestureLock
//
//  Created by hannah on 15/2/16.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GestureLockView.h"

@interface GestureLockViewController : UIViewController<GestureLockViewDelegate>

@property (strong, nonatomic) IBOutlet GestureLockView *lockView;


@end
