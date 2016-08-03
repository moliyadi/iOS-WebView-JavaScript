//
//  MBvlcPlaybackController.h
//  iOS-WebView-JavaScript
//
//  Created by dvt04 on 16/8/3.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBvlcPlaybackError) {
    MBvlcPlaybackError_NoPlayUrl = 1,
    MBvlcPlaybackError_vlcMediaError,
    MBvlcPlaybackError_UnknowError,
};

@class MBvlcPlaybackController;

@protocol vlcPlaybackControllerDelegate <NSObject>

@optional
- (void)vlcPlaybackVC:(MBvlcPlaybackController *)vlcVC playError:(NSError *)errorVlc;

@end

@interface MBvlcPlaybackController : UIViewController

@property (nonatomic, weak) id<vlcPlaybackControllerDelegate> delegateVlcVC;
@property (nonatomic, strong) UIView *movieView;
@property (nonatomic, strong) NSString *strPlayUrl;
@property (nonatomic, strong) NSString *strMovieName;

- (void)closePlaybackController;

@end
