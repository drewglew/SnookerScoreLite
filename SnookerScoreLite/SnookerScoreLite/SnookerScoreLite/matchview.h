//
//  ViewController.h
//  SnookerScorer
//
//  Created by andrew glew on 05/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "player.h"
#import "AdjustPointsViewController.h"
#import "statsViewController.h"
#import "graphView.h"
#import <iAd/iAd.h>


@interface matchview : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate, AdjustPointsDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, graphViewDelegate,ADBannerViewDelegate> {
    int frameNumber;
    int currentColour;
    bool ballReplaced;
    bool advancedCounting;
    int colourStateAtStartOfBreak;
    int colourQuantityAtStartOfBreak;
    statsViewController *statsVC;
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
}
@property (assign) int frameNumber;
@property (assign) int matchTxId;
@property (assign) int currentColour;
@property (assign) bool ballReplaced;
@property (assign) bool advancedCounting;
@property (assign) int colourStateAtStartOfBreak;
@property (assign) int colourQuantityAtStartOfBreak;
@property (nonatomic, strong) NSMutableArray *matchData;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *frameStartDate;


@property (strong, nonatomic) NSMutableArray     *joinedFrameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *visitBallGrid;
/* https://www.youtube.com/watch?v=mdG6XpwwuwI */
-(void) processCurrentUsersHighestBreak;
-(void) processMatchEnd;
-(void) endOfFrame;
-(void) endMatch;

@end

