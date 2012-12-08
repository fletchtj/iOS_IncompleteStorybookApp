//
//  recordViewController.m
//  IncompleteStorybookApp
//
//  Created by TJ Fletcher on 12/3/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import "recordViewController.h"

@interface recordViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    UIButton *playButton;
    UIButton *recordButton;
    UIButton *stopButton;
    UIButton *dismissButton;
}

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *dismissButton;

- (IBAction)recordAudio;
- (IBAction)playAudio;
- (IBAction)stop;
- (IBAction)dismissView;

@end

@implementation recordViewController
@synthesize playButton, recordButton, stopButton, dismissButton, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    playButton.enabled = NO;
    stopButton.enabled = NO;
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    audioPlayer = nil;
    audioRecorder = nil;
    stopButton = nil;
    recordButton = nil;
    playButton = nil;
}

#pragma mark - Custom methods
- (IBAction)recordAudio
{
    if (!audioRecorder.recording)
    {
        [self playSound:@"click" WithExt:@"mp3"];
        
        playButton.enabled = NO;
        stopButton.enabled = YES;
        
        NSArray *dirPaths;
        NSString *docsDir;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *soundFilePath = [docsDir
                                   stringByAppendingPathComponent:@"custom_page1.caf"];
        
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0], AVSampleRateKey, nil];
        
        NSError *error = nil;
        
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
        } else {
            [audioRecorder prepareToRecord];
        }
        
        [audioRecorder record];
    }
}

- (IBAction)playAudio
{
    if (!audioRecorder.recording)
    {
        [self playSound:@"click" WithExt:@"mp3"];
        
        stopButton.enabled = YES;
        recordButton.enabled = NO;

        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", [error localizedDescription]);
        else
            [audioPlayer play];
    }
}

- (IBAction)stop
{
    [self playSound:@"click" WithExt:@"mp3"];
    
    stopButton.enabled = NO;
    playButton.enabled = YES;
    recordButton.enabled = YES;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}

- (IBAction)dismissView
{
    [delegate didDismissModalView];
}

- (void)playSound:(NSString *)fName WithExt:(NSString *)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fName ofType:ext];
    SystemSoundID audioEffect;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    } else {
        NSLog(@"error, file not found: %@", path);
    }
}

#pragma mark - Delegate Methods
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    recordButton.enabled = YES;
    stopButton.enabled = NO;
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
