//
//  GestureLockView.m
//  GestureLock
//
//  Created by hannah on 15/2/4.
//  Copyright (c) 2015年 hannah. All rights reserved.
//

#import "GestureLockView.h"
const static NSUInteger NumberOfNodes = 9;
const static NSUInteger NodesPreRow = 3;
const static CGFloat NodesDefaultWidth =60;
const static CGFloat NodesDefaultHeight =60;
const static CGFloat LineDefaultWidth = 16;

const static CGFloat TrackedLocationInvalidInContentView = -1.0;

@interface GestureLockView(){

    struct{
        unsigned int didBeginWithPasscode :1;
        unsigned int didEndVithPasscode :1;
        unsigned int didCanceledWithPasscode :1;
    }_delegateFlags;
}
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)CGSize buttonSize;
@property(nonatomic,strong)NSArray *buttons;
@property(nonatomic,strong)NSMutableArray *selectedButtons;
@property(nonatomic,assign)CGPoint trackedLocationInContentView;

@end

@implementation GestureLockView

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)_buttonContainsThePoint:(CGPoint)point{
    for (UIButton *button in self.buttons) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

- (void)_lockViewInitialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.lineWidth = LineDefaultWidth;
    
    self.contentInserts = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.contentInserts)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.buttonSize = CGSizeMake(NodesDefaultWidth,NodesDefaultHeight);
    
    self.normalGestureNodesImage = [self imageWithColor:[UIColor greenColor] size:self.buttonSize];
     
    self.selectGestureNOdesImage= [self imageWithColor:[UIColor redColor] size:self.buttonSize];
    
    self.numberOfGestureNodes = NumberOfNodes;
    self.gestureNodesPreRow = NodesPreRow;
    
    self.selectedButtons = [NSMutableArray array];
    
    self.trackedLocationInContentView = CGPointMake(TrackedLocationInvalidInContentView, TrackedLocationInvalidInContentView);
}

#pragma mark -
#pragma mark UIView Overrides
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self _lockViewInitialize];
    }
    return  self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self _lockViewInitialize];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInserts);
    
    CGFloat horizontalNodeMargin = (self.contentView.bounds.size.width - self.buttonSize.width*self.gestureNodesPreRow)/(self.gestureNodesPreRow-1);
    
    NSUInteger numberOfRow = ceilf((self.numberOfGestureNodes*1.0/self.gestureNodesPreRow
                                  ));
    CGFloat verticalNodeMargin = (self.contentView.bounds.size.height - self.buttonSize.height*numberOfRow)/(numberOfRow -1);
    
    for (int i=0; i<self.numberOfGestureNodes; i++) {
        int row = i / self.gestureNodesPreRow;
        int column = i % self.gestureNodesPreRow;
        UIButton *button = [self.buttons objectAtIndex:i];
        button.frame = CGRectMake(floorf((self.buttonSize.width + horizontalNodeMargin) * column), floorf((self.buttonSize.height + verticalNodeMargin) * row), self.buttonSize.width, self.buttonSize.height);
        
          }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self.selectedButtons count] > 0) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        UIButton *firstButton = [self.selectedButtons objectAtIndex:0];
        [bezierPath moveToPoint:[self convertPoint:firstButton.center fromView:self.contentView]];
        
        for (int i = 1; i < [self.selectedButtons count]; i++) {
            UIButton *button = [self.selectedButtons objectAtIndex:i];
            [bezierPath addLineToPoint:[self convertPoint:button.center fromView:self.contentView]];
        }
        
        if (self.trackedLocationInContentView.x != TrackedLocationInvalidInContentView &&
            self.trackedLocationInContentView.y != TrackedLocationInvalidInContentView) {
            [bezierPath addLineToPoint:[self convertPoint:self.trackedLocationInContentView fromView:self.contentView]];
        }
        [bezierPath setLineWidth:self.lineWidth];
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [self.lineColor setStroke];
        [bezierPath stroke];
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationInContentView = [touch locationInView:self.contentView];
    UIButton *touchButton = [self _buttonContainsThePoint:locationInContentView];
    if (touchButton != nil) {
        touchButton.selected = YES;
        [self.selectedButtons addObject:touchButton];
        self.trackedLocationInContentView = locationInContentView;
        
        if (_delegateFlags.didBeginWithPasscode) {
            [self.delegate gestureLockView:self didBeginWithPassCode:[NSString stringWithFormat:@"%d",touchButton.tag]];
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationInContentView = [touch locationInView:self.contentView];
    if (CGRectContainsPoint(self.contentView.bounds,locationInContentView)) {
        UIButton *button = [self _buttonContainsThePoint:locationInContentView];
        if (button != nil && [self.selectedButtons indexOfObject:button] == NSNotFound) {
            button.selected = YES;
            [self.selectedButtons addObject:button];
            if ([self.selectedButtons count] ==1) {
                if (_delegateFlags.didBeginWithPasscode) {
                    [self.delegate gestureLockView:self didBeginWithPassCode:[NSString stringWithFormat:@"%d",button.tag]];
                }
            }
        }
        self.trackedLocationInContentView = locationInContentView;
        [self setNeedsDisplay];
        
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.selectedButtons count]>0) {
        if (_delegateFlags.didEndVithPasscode) {
            NSMutableArray *passcodeArray = [NSMutableArray array];
            for (UIButton *button in self.selectedButtons) {
                [passcodeArray addObject:[NSString stringWithFormat:@"%d",button.tag]];
            }
            [self.delegate gestureLockView:self didEndWithPassCode:[passcodeArray componentsJoinedByString:@","]];
        }
    }
    
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
    }
    [self.selectedButtons removeAllObjects];
    self.trackedLocationInContentView = CGPointMake(TrackedLocationInvalidInContentView, TrackedLocationInvalidInContentView);
    [self setNeedsDisplay];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.selectedButtons count]>0) {
        if (_delegateFlags.didCanceledWithPasscode) {
            NSMutableArray *passcodeArray = [[NSMutableArray alloc] init];
            for (UIButton *button in self.selectedButtons) {
                [passcodeArray addObject:[NSString stringWithFormat:@"%d",button.tag]];
            }
        }
    }
    
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
    }
    
    [self.selectedButtons removeAllObjects];
    self.trackedLocationInContentView = CGPointMake(TrackedLocationInvalidInContentView, TrackedLocationInvalidInContentView);
    
    [self setNeedsDisplay];
    
}

#pragma mark -
#pragma mark Accessors
- (void)setNormalGestureNodesImage:(UIImage *)normalGestureNodeImage{
    if (_normalGestureNodesImage != normalGestureNodeImage) {
        _normalGestureNodesImage = normalGestureNodeImage;
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > normalGestureNodeImage.size.width ? self.buttonSize.width : normalGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > normalGestureNodeImage.size.height ? self.buttonSize.height : normalGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button setImage:normalGestureNodeImage forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectGestureNOdesImage:(UIImage *)selectedGestureNodeImage{
    if (_selectGestureNOdesImage != selectedGestureNodeImage) {
        _selectGestureNOdesImage = selectedGestureNodeImage;
        
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > selectedGestureNodeImage.size.width ? self.buttonSize.width : selectedGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > selectedGestureNodeImage.size.height ? self.buttonSize.height : selectedGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button setImage:selectedGestureNodeImage forState:UIControlStateSelected];
            }
        }
    }
}

- (void)setDelegate:(id<GestureLockViewDelegate>)delegate{
    _delegate = delegate;
    
    _delegateFlags.didBeginWithPasscode = [delegate respondsToSelector:@selector(gestureLockView:didBeginWithPassCode:)];
    _delegateFlags.didEndVithPasscode = [delegate respondsToSelector:@selector(gestureLockView:didEndWithPassCode:)];
    _delegateFlags.didCanceledWithPasscode = [delegate respondsToSelector:@selector(gestureLockView:didCanceledWithPassCode:)];
}

- (void)setNumberOfGestureNodes:(NSUInteger)numberOfGestureNodes{
    if (_numberOfGestureNodes != numberOfGestureNodes) {
        _numberOfGestureNodes = numberOfGestureNodes;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button removeFromSuperview];
            }
        }
        
        NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:numberOfGestureNodes];
        for (NSUInteger i = 0; i < numberOfGestureNodes; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.userInteractionEnabled = NO;
            button.frame = CGRectMake(0, 0, self.buttonSize.width, self.buttonSize.height);
            button.backgroundColor = [UIColor clearColor];
            if (self.normalGestureNodesImage != nil) {
                [button setImage:self.normalGestureNodesImage forState:UIControlStateNormal];
            }
            
            if (self.selectGestureNOdesImage != nil) {
                [button setImage:self.selectGestureNOdesImage forState:UIControlStateSelected];
            }
            
            [buttonArray addObject:button];
            [self.contentView addSubview:button];
        }
        self.buttons = [buttonArray copy];
    }
}
@end
