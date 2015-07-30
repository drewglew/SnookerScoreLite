//
//  labelFrame.m
//  SnookerScorer
//
//  Created by andrew glew on 07/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "frame.h"

@implementation frame
@synthesize matchScore;
@synthesize frameScore;
@synthesize frameHighestBreak;
@synthesize frameBallsPotted;
@synthesize currentBreak;
@synthesize frameHighestBreakHistory;
@synthesize frameTransaction;
@synthesize foulScore;


- (id)init{
    if ((self = [super init])) {
        if (!frameTransaction) {
           frameTransaction = [[NSMutableArray alloc] init];
        }
        
        if (!frameHighestBreakHistory) {
            frameHighestBreakHistory = [[NSMutableArray alloc] init];
            currentBreak = [[snookerbreak alloc] init];
        }
    }
    return self;
}


- (id)mutableCopyWithZone:(NSZone *)zone {
    frame *f = [[[self class] allocWithZone:zone] init];
    f.matchScore   = self.matchScore;
    f.frameScore = self.frameScore;
    f.frameIndex = self.frameIndex;
    f.frameBallsPotted = self.frameBallsPotted;
    f.frameHighestBreak = self.frameHighestBreak;
    f.foulScore = self.foulScore;
 //   f.frameHighestBreakHistory = self.frameHighestBreakHistory;

    NSMutableArray *copiedData = [[self frameHighestBreakHistory] mutableCopyWithZone:zone];
    f.frameHighestBreakHistory = copiedData;


    return f;
}



// this matchScore should sit elsewhere.
-(int)matchScore {
    return matchScore;
}

-(void)setMatchScore:(int) value {
    matchScore = value;
    NSString *labelScore = [NSString stringWithFormat:@"%d",matchScore];
    self.text = labelScore;
}

-(void)incrementMatchScore {
    matchScore ++;
    NSString *labelScore = [NSString stringWithFormat:@"%d",matchScore];
    self.text = labelScore;
}



-(int)frameIndex {
    return frameIndex;
}

-(void)setFrameIndex:(int) value {
    frameIndex = value;
}

-(int)frameScore {
    return frameScore;
}

-(void)setFrameScore:(int) value {
    frameScore = value;
}

-(int)foulScore {
    return foulScore;
}

-(void)setFoulScore:(int) value {
    foulScore = value;
}


-(void)increaseFrameScore:(int) value {
    frameScore = value;
}

-(int)frameBallsPotted{
    // should be able to get length of new transaction array
    return frameBallsPotted;
}

-(void)setFrameBallsPotted:(int) value {
    frameBallsPotted = value;
}

-(int)frameHighestBreak{
    return frameHighestBreak;
}

-(void)setFrameHighestBreak:(int) value {
    frameHighestBreak = value;
}


-(void)incrementFrameBallsPotted {
    frameBallsPotted ++;
}


-(void)addBalltoBreak:(ball*) newpot {
    [currentBreak incrementScore:newpot];
    
}


-(NSMutableArray*) frameHighestBreakHistory {
    return frameHighestBreakHistory;
}



-(void)setFrameHighestBreak:(int) value :(int) frameno :(NSMutableArray*) breakHistory {
    
    [frameHighestBreakHistory removeAllObjects];
    [frameHighestBreakHistory addObjectsFromArray:breakHistory];
    //frameHighestBreakHistory = breakHistory;
    frameHighestBreak = value;
}


@end
