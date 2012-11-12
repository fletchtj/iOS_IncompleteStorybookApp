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

@interface ViewController : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate> {
    AVAudioPlayer *player;
    IBOutlet UIButton *playButton;
}

- (IBAction)playButtonPressed:(UIButton *)sender;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, retain) UIButton *playButton;

@end
