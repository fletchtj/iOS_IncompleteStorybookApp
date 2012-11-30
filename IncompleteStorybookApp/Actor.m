//
//  Actor.m
//  AudioTest01
//
//  Created by TJ Fletcher on 11/9/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import "Actor.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle/180.0*M_PI)
#define RADIANS_TO_DEGREES(rads) (rads/M_PI * 180.0)

@implementation Actor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)rotate:(float)count Duration:(float)duration
{
    count--;
    void (^anim) (void) = ^{
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
    };
    
    void (^after) (BOOL) = ^(BOOL f) {
        if (count) {
            [self rotate:count Duration:duration];
        }
    };
    
    NSUInteger opts = UIViewAnimationOptionCurveLinear;
    
    [UIView animateWithDuration:duration delay:0 options:opts animations:anim completion:after];
}

- (void)rotate:(NSTimeInterval)duration degrees:(CGFloat)degrees
{
    CGAffineTransform transform = self.transform;
    CGFloat curAngle = RADIANS_TO_DEGREES(atan2f(transform.b, transform.a));

    degrees = degrees + curAngle;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [self.layer setTransform:CATransform3DMakeRotation(DEGREES_TO_RADIANS(degrees), 0, 0, 1)];
    [UIView commitAnimations];
}

- (void)rotate360:(NSTimeInterval)duration repeat:(CGFloat)repeat
{
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = duration;
    fullRotation.repeatCount = repeat;
    [self.layer addAnimation:fullRotation forKey:@"360"];
}

- (void)moveToPoint:(CGPoint)fPos FromPoint:(CGPoint)oPos WithDuration:(NSTimeInterval)duration
{
//    void (^anim) (void) = ^{
//        self.center = fPos;
//    };
//    NSUInteger opts = UIViewAnimationOptionCurveEaseOut;
//    [UIView animateWithDuration:duration delay:0 options:opts animations:anim completion:NULL];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [pathAnimation setValue:@"moveAnim" forKey:@"name"];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //Setting Endpoint of the animation
    CGPoint endPoint = fPos;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, oPos.x, oPos.y);
    CGFloat cpY = (endPoint.y - oPos.y)/2.0 + endPoint.y;
    CGPathAddCurveToPoint(curvedPath, NULL, oPos.x, cpY, oPos.x, cpY, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    pathAnimation.duration = duration;
    pathAnimation.delegate = self;
    [self.layer addAnimation:pathAnimation forKey:@"move"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (@"moveAnim" == [anim valueForKey:@"name"]) {
        CGRect frame = [[self.layer presentationLayer] frame];
        CGPoint fPos = CGPointMake(frame.origin.x+frame.size.width/2.0, frame.origin.y+frame.size.height/2.0);
        self.center = fPos;
        [self.layer removeAnimationForKey:@"move"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
