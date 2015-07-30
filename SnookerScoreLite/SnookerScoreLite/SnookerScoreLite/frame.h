//
//  labelFrame.h
//  SnookerScorer
//
//  Created by andrew glew on 07/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "snookerbreak.h"

@interface frame : UILabel {
    int matchScore;
    int frameIndex;
    int frameScore;
    int frameHighestBreak;
    int frameBallsPotted;
    int foulScore;
    NSMutableArray *frameHighestBreakHistory;
    NSMutableArray *frameTransaction;
    
}

@property (assign) int matchScore;
@property (assign) int frameIndex;
@property (assign) int frameScore;
@property (assign) int frameHighestBreak;
@property (assign) int frameBallsPotted;
@property (assign) int foulScore;
@property (strong, nonatomic) NSMutableArray *frameHighestBreakHistory;
@property (strong, nonatomic) NSMutableArray *frameTransaction; //20150418
@property (strong, nonatomic) snookerbreak     *currentBreak;
-(void)addBalltoBreak:(ball*) newpot ;
-(void)incrementMatchScore;
-(void)setFrameHighestBreak:(int) value :(int) frameno :(NSMutableArray*) breakHistory;
-(void)incrementFrameBallsPotted;
-(void)increaseFrameScore:(int) value;
@end
