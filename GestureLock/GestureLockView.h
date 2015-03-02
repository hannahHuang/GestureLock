//
//  GestureLockView.h
//  GestureLock
//
//  Created by hannah on 15/2/4.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GestureLockView;

@protocol GestureLockViewDelegate <NSObject>
@optional
-(void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPassCode:(NSString *)code;

-(void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPassCode:(NSString *)code;

-(void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPassCode:(NSString *)code;

@end

@interface GestureLockView : UIView

@property(nonatomic,assign)NSUInteger numberOfGestureNodes;
@property(nonatomic,assign)NSUInteger gestureNodesPreRow;

@property(nonatomic,strong)UIImage *normalGestureNodesImage;
@property(nonatomic,strong)UIImage *selectGestureNOdesImage;

@property(nonatomic,strong)UIColor *lineColor;
@property(nonatomic,assign) CGFloat lineWidth;

@property(nonatomic,strong,readonly)UIView *contentView;
@property(nonatomic,assign)UIEdgeInsets contentInserts;

@property(nonatomic,weak)id<GestureLockViewDelegate> delegate;



@end
