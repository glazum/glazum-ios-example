//
//  com_glazumViewController.m
//  GlazumExample3
//
//  Created by Mikhail Shkutkov on 6/13/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import "com_glazumViewController.h"

@interface com_glazumViewController ()
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *playerButtons;
@property (nonatomic, retain) IBOutlet UISwitch *loopSwitch;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@end

@implementation com_glazumViewController

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
    self.playerButtons.selectedSegmentIndex = 2;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
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
        [self.audioPlayer play];
    }
    if (control.selectedSegmentIndex == 1) {
        [self.audioPlayer pause];
    }
    if (control.selectedSegmentIndex == 2) {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
    }
}

- (IBAction)loopChanged:(id)sender
{
    UISwitch *control = sender;
    if (control.isOn) {
        self.audioPlayer.numberOfLoops = -1;
    } else {
        self.audioPlayer.numberOfLoops = 0;
    }
}

- (IBAction)volumeChanged:(id)sender
{
    UISlider *control = sender;
    self.audioPlayer.volume = control.value;
}

@end
