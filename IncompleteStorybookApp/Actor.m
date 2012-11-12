//
//  Actor.m
//  AudioTest01
//
//  Created by TJ Fletcher on 11/9/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import "Actor.h"

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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
