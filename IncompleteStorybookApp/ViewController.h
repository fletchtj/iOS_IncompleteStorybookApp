//
//  ViewController.h
//  AudioTest01
//
//  Created by TJ Fletcher on 11/3/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "recordViewController.h"

@interface ViewController : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate, ModalViewControllerDelegate> {
    AVAudioPlayer *player;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *recordCustomButton;
}

- (IBAction)playButtonPressed:(UIButton *)sender;
- (IBAction)recordCustomPressed:(UIButton *)sender;
- (IBAction)removeCustomAudioFile:(UIButton *)sender;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *recordCustomButton;

@end
