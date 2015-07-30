//
//  snookerbreak.h
//  SnookerScorer
//
//  Created by andrew glew on 08/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ball.h"

@interface snookerbreak : UITextField {
    int frameScore;
    int breakScore;
    int highestBreak;
    int nbrBallsPotted;
}
@property (assign) int frameScore;
@property (assign) int breakScore;
@property (assign) int highestBreak;
@property (assign) int highestBreakFrameNo;
@property (assign) int nbrBallsPotted;
@property (nonatomic, strong) NSMutableArray *pottedBalls;
@property (nonatomic, strong) NSMutableArray *pottedBallTimeStamps;
@property (strong, nonatomic) ball     *currentBall;
-(void)clearBreak:(UIImageView*) imageCueBall;

-(bool)incrementScore:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView ;

-(void)incrementScore:(ball*) pottedball;

@end
