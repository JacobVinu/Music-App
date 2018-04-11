//
//  ViewController.h
//  MusicPlayer
//
//  Created by MAC  on 11/04/18.
//  Copyright © 2018 MAC . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController<MPMediaPickerControllerDelegate>
{
    MPMusicPlayerController *musicPlayer;

}
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

- (IBAction)volumeChanged:(id)sender;
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

- (void) registerMediaPlayerNotifications;


@end

