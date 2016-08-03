//
//  MBvlcPlaybackController.m
//  iOS-WebView-JavaScript
//
//  Created by dvt04 on 16/8/3.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "MBvlcPlaybackController.h"
#import <MobileVLCKit/MobileVLCKit.h>

@interface MBvlcPlaybackController ()

@end

@implementation MBvlcPlaybackController
{
    VLCMediaPlayer *_vlcPlayer;
}
@synthesize strPlayUrl;
@synthesize strMovieName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.movieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.movieView];
    
    [self bindFrameSubview:self.movieView superview:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    /* setup the media player instance, give it a delegate and something to draw into */
    _vlcPlayer = [[VLCMediaPlayer alloc] init];
    _vlcPlayer.delegate = (id<VLCMediaPlayerDelegate>)self;
    _vlcPlayer.drawable = self.movieView;
    
    /* listen for notifications from the player */
    [_vlcPlayer addObserver:self forKeyPath:@"time" options:0 context:nil];
    [_vlcPlayer addObserver:self forKeyPath:@"remainingTime" options:0 context:nil];
    
    /* create a media object and give it to the player */
    if (nil == self.strPlayUrl || [self.strPlayUrl length] == 0) {
        NSLog(@"strPlayUrl_not_set");
        if (self.delegateVlcVC != nil && [self.delegateVlcVC respondsToSelector:@selector(vlcPlaybackVC:playError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:MBvlcPlaybackError_NoPlayUrl userInfo:nil];
            [_delegateVlcVC vlcPlaybackVC:self playError:error];
        }
        
        return;
    }
    NSURL *urlPlay = [NSURL URLWithString:self.strPlayUrl];
    _vlcPlayer.media = [VLCMedia mediaWithURL:urlPlay];
    
    [_vlcPlayer play];
    
#if 1 //mabiao test UI add
    //exit button
    UIButton *btnExit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [btnExit setBackgroundColor:[UIColor redColor]];
    [btnExit setTitle:@"exit" forState:UIControlStateNormal];
    [self.view addSubview:btnExit];
    [btnExit addTarget:self action:@selector(closePlaybackController) forControlEvents:UIControlEventTouchUpInside];
    
    //title label
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnExit.frame), 0, self.view.bounds.size.width - CGRectGetWidth(btnExit.frame), CGRectGetHeight(btnExit.frame))];
    [labTitle setBackgroundColor:[UIColor blueColor]];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    if (self.strMovieName) {
        [labTitle setText:self.strMovieName];
    }
    [self.view addSubview:labTitle];
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_vlcPlayer) {
        @try {
            [_vlcPlayer removeObserver:self forKeyPath:@"time"];
            [_vlcPlayer removeObserver:self forKeyPath:@"remainingTime"];
        }
        @catch (NSException *exception) {
            NSLog(@"we weren't an observer yet");
        }

        if (_vlcPlayer.media) {
            [_vlcPlayer stop];
        }
        
        if (_vlcPlayer) {
            _vlcPlayer = nil;
        }

    }
    
}

- (void)closePlaybackController
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
        
    }];
}

#pragma mark - 
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    NSLog(@"mediaPlayerStateChanged_state:%d", _vlcPlayer.state); //mabiao
    VLCMediaPlayerState currentState = _vlcPlayer.state;
    
    /* distruct view controller on error */
    if (currentState == VLCMediaPlayerStateError) {
        NSLog(@"mediaPlayerStateChanged_VLCMediaPlayerStateError");
        if (self.delegateVlcVC != nil && [self.delegateVlcVC respondsToSelector:@selector(vlcPlaybackVC:playError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:MBvlcPlaybackError_vlcMediaError userInfo:nil];
            [_delegateVlcVC vlcPlaybackVC:self playError:error];
        }
    }
    
    /* or if playback ended */
    if (currentState == VLCMediaPlayerStateEnded || currentState == VLCMediaPlayerStateStopped) {
        
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"kvo:position:%f, remainingTime:%@, time:%@, lengthTime:%@", [_vlcPlayer position], [[_vlcPlayer remainingTime] stringValue], [[_vlcPlayer time] stringValue], [[_vlcPlayer lengthTime] stringValue]); //test
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - common
- (void)bindFrameSubview:(UIView *)subview superview:(UIView *)superview
{
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [superview addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(subview)]];
    [superview addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(subview)]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
