//
//  com_glazumViewController.m
//  GlazumExample3
//
//  Created by Mikhail Shkutkov on 6/13/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import "ViewController.h"
#import <Glazum/Glazum.h>

static const float EPSILON = 1e-5;
@interface ViewController ()
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *playerButtons;
@property (nonatomic, retain) IBOutlet UISwitch *loopSwitch;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/RanzDesVaches.m4a", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
	self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0.5;
    self.volumeSlider.value = self.audioPlayer.volume;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [Glazum setMarker:@"playback did finish"];
    self.playerButtons.selectedSegmentIndex = 2;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [Glazum setMarker:@"playback interrupted"];
    self.playerButtons.selectedSegmentIndex = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePlayerState:(id)sender
{
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        [Glazum setMarker:@"play pressed"];
        [self.audioPlayer play];
    }
    if (control.selectedSegmentIndex == 1) {
        [Glazum setMarker:@"pause pressed"];
        [self.audioPlayer pause];
    }
    if (control.selectedSegmentIndex == 2) {
        [Glazum setMarker:@"stop pressed"];
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
    }
}

- (IBAction)loopChanged:(id)sender
{
    UISwitch *control = sender;
    BOOL isPlayed = self.audioPlayer.playing;    
    
    /* 
        This is an example of doBefore/doAfter usage.
        We pause audio player in case of question presence and then resume playback state
    */
    [Glazum setMarker:@"loop changed" doBefore:^(BOOL willShowQuestion) {
        if (willShowQuestion && isPlayed) {
            [self.audioPlayer pause];
        }
    } doAfter:^(BOOL questionWasShown) {
        if (questionWasShown && isPlayed) {
            [self.audioPlayer play];
        }
    }];
    
    if (control.isOn) {
        [Glazum setMarker:@"loop on"];
        self.audioPlayer.numberOfLoops = -1;
    } else {
        [Glazum setMarker:@"loop off"];
        self.audioPlayer.numberOfLoops = 0;
    }
}

- (IBAction)volumeChanged:(id)sender
{
    UISlider *control = sender;
    self.audioPlayer.volume = control.value;
    /* 
        Set as many markers as possible, so after application submit 
        you'll have great possibility to bind questions
    */
    [Glazum setMarker:@"volume changed"];
    if (self.audioPlayer.volume < EPSILON) {
        [Glazum setMarker:@"volume changed to minimum"];
    }
    if (self.audioPlayer.volume > 1 - EPSILON) {
        [Glazum setMarker:@"volume changed to maximum"];
    }
}

@end
