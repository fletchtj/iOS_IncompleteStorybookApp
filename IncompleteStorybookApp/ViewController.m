//
//  ViewController.m
//  AudioTest01
//
//  Created by TJ Fletcher on 11/3/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import "ViewController.h"
#import "Actor.h"

@interface ViewController (){
    IBOutlet UIButton *btn0;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    IBOutlet UIButton *btn4;
    IBOutlet UIButton *btn5;
    IBOutlet UIButton *btn6;
    IBOutlet UIImageView *jack;
    IBOutlet UIImageView *jill;
    IBOutlet UIImageView *cloud;
    NSMutableArray *markerTimings;
    NSArray *wordButtons;
    NSTimer *timer;
    int nextWord;
    CGPoint oPosJack;
}

@end

@implementation ViewController
@synthesize player, playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];

    [jack addGestureRecognizer:tapGesture];
    [jack addGestureRecognizer:panGesture];
    oPosJack = jack.center;
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    wordButtons = [[NSArray alloc] initWithObjects:btn0, btn1, btn2, btn3, btn4, btn5, btn6, nil];
    
    // audio file for page
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"page1" ofType:@"aif"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    
    // set up audio player
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    if (self.player) {
        [self.player prepareToPlay];
        [self.player setDelegate:self];
    }
    
    // load the marker list and determine the timing for karaoke effect
    AudioFileID audioFile;
    OSStatus theErr = noErr;
    theErr = AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, 0, &audioFile);
    if(theErr == noErr)
    {
        UInt32 dataSize  = 0;
        theErr = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyMarkerList, &dataSize, 0);
        
        if(theErr == noErr)
        {
            AudioFileMarkerList *markerList = (AudioFileMarkerList *)malloc(dataSize);
            theErr = AudioFileGetProperty(audioFile, kAudioFilePropertyMarkerList, &dataSize, markerList);
            
            if(theErr == noErr)
            {
                markerTimings = [[NSMutableArray alloc] init];
                [markerTimings addObject:[NSNumber numberWithInt:0]]; // this represents first flag (generally first marker is for start of second word)

                // need to get the sample rate in order to convert frame position to seconds.
                theErr = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyDataFormat, &dataSize, 0);
                if(theErr == noErr)
                {
                    AudioStreamBasicDescription streamDesc;
                    theErr = AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &dataSize, &streamDesc);
                    if(theErr == noErr)
                    {
                        for(int i = 0; i < markerList->mNumberMarkers; i++) {
                            [markerTimings addObject:[NSNumber numberWithFloat:(float)markerList->mMarkers[i].mFramePosition/streamDesc.mSampleRate]];
                            CFRelease(markerList->mMarkers[i].mName);
                        }
                    }
                }
            }
            
            free(markerList);
        }
    }
    theErr = AudioFileClose(audioFile);
    assert(theErr == noErr);
}

- (void)viewDidAppear:(BOOL)animated
{
    jack.center = oPosJack;
}

- (void)viewDidUnload
{
    self.player = nil;
    [timer invalidate];
    timer = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.player = nil;
    [timer invalidate];
    timer = nil;
}


- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
    [playButton setBackgroundImage:((p.playing == YES) ? [UIImage imageNamed:@"btn_pause.png"]: [UIImage imageNamed:@"btn_play.png"]) forState:UIControlStateNormal];
}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
    [p pause];
    [self updateViewForPlayerState:p];
    [timer invalidate];
    timer = nil;
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
    if ([p play]) {
        [self updateViewForPlayerState:p];
    }
    else
        NSLog(@"Could not play %@\n", p.url);
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
    if (player.playing == YES)
        [self pausePlaybackForPlayer: player];
    else {
        [player setCurrentTime:0.];
        [self startPlaybackForPlayer: player];
        for (int i=0; i<[wordButtons count]; i++){
            [[wordButtons objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];
        }
        [btn0 setBackgroundColor:[UIColor yellowColor]];
        [UIView animateWithDuration:0.75 delay:0.25 options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             [btn0 setBackgroundColor:[UIColor clearColor]];
                         } completion:^(BOOL finished) { }
         ];
        nextWord = 1;
        float timeInterval = [[markerTimings objectAtIndex:nextWord] floatValue] - [[markerTimings objectAtIndex:nextWord-1] floatValue];
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
    }
}

-(void)updateTimer {
    [timer invalidate];
    timer = nil;
    
    [[wordButtons objectAtIndex:nextWord] setBackgroundColor:[UIColor yellowColor]];
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [[wordButtons objectAtIndex:nextWord] setBackgroundColor:[UIColor clearColor]];
                     } completion:^(BOOL finished) { }
     ];
    nextWord++;
    if (nextWord < [markerTimings count]) {
        float timeInterval = [[markerTimings objectAtIndex:nextWord] floatValue] - [[markerTimings objectAtIndex:nextWord-1] floatValue];
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
    }
}


#pragma mark Handle Gestures

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.5 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             gestureRecognizer.view.center = oPosJack;
                         }
                         completion:^(BOOL finished){
                             if (finished) { }
                         }];
        [(Actor *)gestureRecognizer.view rotate:4 Duration:0.125];

    }
    
}
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat yPos = (gestureRecognizer.view.center.y + translation.y < oPosJack.y) ? oPosJack.y : gestureRecognizer.view.center.y + translation.y;
        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x, yPos);
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPosition = CGPointMake(418.0, 314.0);
        [UIView animateWithDuration:0.75 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             gestureRecognizer.view.center = finalPosition;
                         }
                         completion:NULL];
    }
}

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    if (flag == NO)
        NSLog(@"Playback finished unsuccessfully");
    
    [p setCurrentTime:0.];
    [self updateViewForPlayerState:p];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
    NSLog(@"ERROR IN DECODE: %@\n", error);
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
    NSLog(@"Interruption begin. Updating UI for new state");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
    NSLog(@"Interruption ended. Resuming playback");
    [self startPlaybackForPlayer:p];
}

@end
