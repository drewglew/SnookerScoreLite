//
//  textScore.m
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "player.h"
#import "frame.h"
#import "graphView.h"



@implementation player
@synthesize frameScore;
@synthesize breakScore;
@synthesize highestBreak;
@synthesize highestBreakFrameNo;
@synthesize nbrBallsPotted;
@synthesize currentFrameIndex;
@synthesize currentFrame;
@synthesize highestBreakHistory;
@synthesize frames;
@synthesize nbrOfBreaks;
@synthesize sumOfBreaks;
@synthesize playersBreaks;
@synthesize playerIndex;



-(void) createFrame:(int) value {
    if (!currentFrame) {
        currentFrame = [[frame alloc] init];
    }
    currentFrame.frameIndex = value;
    currentFrame.frameScore = 0;
    currentFrame.frameHighestBreak = 0;
    currentFrameIndex = value;

    
}


-(int)frameScore {
    return currentFrame.frameScore;
}

// is this called at all?
-(void)setFrameScore:(int) value {
        currentFrame.frameScore = currentFrame.frameScore + value;
    
        NSString *labelScore = [NSString stringWithFormat:@"%d",currentFrame.frameScore];
        self.text = labelScore;
}

//Added April 2015 - refactor.
-(void)updateFrameScore:(int) value {
    currentFrame.frameScore = value;
    
    NSString *labelScore = [NSString stringWithFormat:@"%d",currentFrame.frameScore];
    self.text = labelScore;
}




-(void)setFoulScore:(int) value {
    currentFrame.frameScore = currentFrame.frameScore + value;
    currentFrame.foulScore = currentFrame.foulScore + value;
    NSString *labelScore = [NSString stringWithFormat:@"%d",currentFrame.frameScore];
    self.text = labelScore;
}



-(int)breakScore {
    return breakScore;
}

-(void)addBreakScore:(int) value {
    currentFrame.frameScore = currentFrame.frameScore + value;
    
    NSNumber* playerBreak = [NSNumber numberWithInt:value];
    
    if ([self.playersBreaks count] == 0) {
        self.playersBreaks = [NSMutableArray arrayWithObjects:playerBreak, nil];
    } else {
        [self.playersBreaks addObject:playerBreak];
    }

    

    NSString *labelScore = [NSString stringWithFormat:@"%d",currentFrame.frameScore];
    self.text = labelScore;
}

-(void)displayHighestBreak {
    NSString *labelHighestScore = [NSString stringWithFormat:@"%d",self.highestBreak];
    self.text = labelHighestScore;
}

-(void)displayBallsPotted {
    NSString *labelBallsPotted = [NSString stringWithFormat:@"%d",self.nbrBallsPotted];
    self.text = labelBallsPotted;
}

-(void)setBreakScore:(int) value {
    breakScore = value;
}

-(int)nbrOfBreaks {
    return nbrOfBreaks;
}

-(void)setNbrOfBreaks:(int) value {
    nbrOfBreaks = value;
}

-(int)sumOfBreaks {
    return sumOfBreaks;
}

-(void)setSumOfBreaks:(int) value {
    sumOfBreaks = value;
}


-(int)highestBreak {
    return highestBreak;
}

-(void)setHighestBreak:(int) value {
    highestBreak = value;
}

-(int)currentFrameIndex {
    return currentFrameIndex;
}

-(void)setCurrentFrameIndex:(int) value {
    currentFrameIndex = value;
}

-(NSMutableArray*) frames {
    return frames;
}

-(void)setFrames:(NSMutableArray *)value {
    frames = value;
}


-(void)setHighestBreak:(int) value :(int) frameno :(NSMutableArray*) breakHistory {
    highestBreak = value;
    highestBreakFrameNo = frameno;
    
    
    NSMutableArray *hiBreakHistory = [NSMutableArray arrayWithArray:breakHistory];

    highestBreakHistory = hiBreakHistory;
}

-(int)nbrBallsPotted {
    return nbrBallsPotted;
}


-(void)incrementNbrBalls:(int) value {
    nbrBallsPotted = nbrBallsPotted + value;
    
}

-(void)setNbrBallsPotted:(int) value {
    nbrBallsPotted = value;
}

-(void)resetFrameScore:(int) value {

    if ([self.frames count] == 0) {
        self.frames = [[NSMutableArray alloc] init];
    }
    
    [self.frames addObject:[currentFrame mutableCopy]];
    
    currentFrame.frameScore = 0;
    currentFrame.foulScore = 0;
    currentFrame.frameHighestBreak = 0;
    [currentFrame.frameHighestBreakHistory removeAllObjects];
    [currentFrame.frameTransaction removeAllObjects];
    [currentFrame setFrameBallsPotted:0];
    breakScore = 0;
    NSString *labelScore = [NSString stringWithFormat:@"%d",currentFrame.frameScore];
    self.text = labelScore;
}




@end


