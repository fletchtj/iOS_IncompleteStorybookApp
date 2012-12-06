//
//  Actor.h
//  AudioTest01
//
//  Created by TJ Fletcher on 11/9/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Actor : UIImageView
- (void)rotate:(float)count Duration:(float)duration;
- (void)rotate:(NSTimeInterval)duration degrees:(CGFloat)degrees;
- (void)rotate360:(NSTimeInterval)duration repeat:(CGFloat)repeat;
- (void)moveToPoint:(CGPoint)fPos FromPoint:(CGPoint)oPos WithDuration:(NSTimeInterval)duration;
- (void)swing:(NSTimeInterval)duration repeat:(CGFloat)repeat;

- (void)playSound:(NSString *)fName WithExt:(NSString *)ext;
@end
