//
//  textScore.h
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "frame.h"

@interface player : UITextField {
    int frameScore;
    int breakScore;
    int highestBreak;
    int nbrBallsPotted;
    int currentFrameIndex;
    int nbrOfBreaks;
    int sumOfBreaks;
    int playerIndex;
    NSMutableArray     *highestBreakHistory;
    NSMutableArray *playersBreaks;
    NSMutableArray *frames;
}

@property (assign) int frameScore;
@property (assign) int breakScore;
@property (assign) int highestBreak;
@property (assign) int highestBreakFrameNo;
@property (assign) int nbrBallsPotted;
@property (assign) int currentFrameIndex;
@property (assign) int nbrOfBreaks;
@property (assign) int sumOfBreaks;
@property (assign) int playerIndex;
@property (nonatomic, strong) NSMutableArray *frames;
@property (strong, nonatomic) frame     *currentFrame;
@property (strong, nonatomic) NSMutableArray     *playersBreaks;
@property (strong, nonatomic) NSMutableArray     *highestBreakHistory;


-(void)resetFrameScore:(int) value;
-(void)addBreakScore:(int) value;
-(void)updateFrameScore:(int) value;
-(void)setHighestBreak:(int) value :(int) frameno :(NSMutableArray*) breakHistory;
-(void)displayHighestBreak;
-(void)displayBallsPotted;
-(void)setFoulScore:(int) value;
-(void)incrementNbrBalls:(int) value;
-(void)createFrame:(int) value;
@end
