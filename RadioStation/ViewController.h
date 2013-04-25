//
//  ViewController.h
//  RadioStation
//
//  Created by marujun on 13-4-25.
//  Copyright (c) 2013年 马汝军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>{
    
    __weak IBOutlet UISlider *volumeSlider;
    __weak IBOutlet UIButton *play_button;
}

@property(nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;



- (IBAction)changeVolume:(id)sender;

@end
