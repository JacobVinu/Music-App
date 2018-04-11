//
//  ViewController.m
//  MusicPlayer
//
//  Created by MAC  on 11/04/18.
//  Copyright © 2018 MAC . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize musicPlayer;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMediaplayer];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self removeObservers];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self registerMediaPlayerNotifications];
}

-(void)removeObservers
{
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object: musicPlayer];
    
    [musicPlayer endGeneratingPlaybackNotifications];
}
-(void)setupMediaplayer
{
    musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    
    [_volumeSlider setValue:[musicPlayer volume]];
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        
        [_playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        [_playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    }
    

}
- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handleNowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handlePlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handleVolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}


- (void) handleNowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork)
    {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [_artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString)
    {
        _titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    }
    else
    {
        _titleLabel.text = @"Title: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
    {
        _artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    }
    else
    {
        _artistLabel.text = @"Artist: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString)
    {
        _albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    }
    else
    {
        _albumLabel.text = @"Album: Unknown album";
    }
    
}

- (void) handlePlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused)
    {
        [_playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        
    }
    else if (playbackState == MPMusicPlaybackStatePlaying)
    {
        [_playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
    }
    else if (playbackState == MPMusicPlaybackStateStopped)
    {
        
        [_playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
        
    }
    
}

- (void) handleVolumeChanged: (id) notification
{
    [_volumeSlider setValue:[musicPlayer volume]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)volumeChanged:(id)sender
{
    [musicPlayer setVolume:[_volumeSlider value]];

}

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentViewController:mediaPicker animated:YES completion:nil];

}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
   [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
   [self dismissModalViewControllerAnimated: YES];
}
- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];

}

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        [musicPlayer pause];
        
    }
    else
    {
        [musicPlayer play];
        
    }

}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];

}
@end
