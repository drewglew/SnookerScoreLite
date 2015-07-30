//
//  snookerbreak.m
//  SnookerScorer
//
//  Created by andrew glew on 08/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "snookerbreak.h"

@implementation snookerbreak
@synthesize frameScore;
@synthesize breakScore;
@synthesize highestBreak;
@synthesize highestBreakFrameNo;
@synthesize nbrBallsPotted;
@synthesize currentBall;
@synthesize pottedBalls;
@synthesize pottedBallTimeStamps;

- (id)init{
    if ((self = [super init])) {
        if (!currentBall) {
            currentBall = [[ball alloc] init];
            self.pottedBalls = [[NSMutableArray alloc] init];
            self.pottedBallTimeStamps = [[NSMutableArray alloc] init];
        }
    }
    return self;
}


-(int)breakScore {
    return breakScore;
}

-(void)setBreakScore:(int) value {
    breakScore = value;
}

-(int)highestBreak {
    return highestBreak;
}

-(void)setHighestBreak:(int) value {
    highestBreak = value;
}

-(int)nbrBallsPotted {
    return nbrBallsPotted;
}

-(void)setNbrBallsPotted:(int) value {
    nbrBallsPotted = nbrBallsPotted + value;
}


// used by ViewController
-(bool)incrementScore:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView {
    
    // here we can validate the number of reds left on the table??
    
    
    if (breakScore + currentBall.pottedPoints > 155) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unforunately it is impossible to score such a high break!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault ;
        [alert show];
        return false;
    }
    else {
        
        if (breakScore==0) {
            self.hidden = false;
            imagePottedBall.hidden = false;
        }
        currentBall = pottedball;
        breakScore = breakScore + currentBall.pottedPoints;
        if (breakScore > highestBreak) {
            highestBreak = breakScore;
        }
        
        
        UIImage * toImage = [UIImage imageNamed:currentBall.imageNameLarge];
        [UIView transitionWithView:breakView
                          duration:0.5f
                           options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            imagePottedBall.image = toImage;
                        } completion:nil];
        
        //20150504 new amendment START
        

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
        //20150504 new amendment END
        
        if ([self.pottedBalls count] == 0) {
            self.pottedBalls = [NSMutableArray arrayWithObjects:currentBall, nil];
            self.pottedBallTimeStamps  = [NSMutableArray arrayWithObjects:rightNow, nil];
        } else {
            [self.pottedBalls addObject:pottedball];
            [self.pottedBallTimeStamps addObject:rightNow];
        }

        NSString *labelScore = [NSString stringWithFormat:@"%d",self.breakScore];
        self.text = labelScore;
        return true;
    }
}



/* used by the frame object */
-(void)incrementScore:(ball*) pottedball {

    if (breakScore==0) {
        self.hidden = false;
    }
    
    currentBall = pottedball;
    breakScore = breakScore + currentBall.pottedPoints;
    if (breakScore > highestBreak) {
        highestBreak = breakScore;
    }
    
    if ([self.pottedBalls count] == 0) {
        self.pottedBalls = [NSMutableArray arrayWithObjects:currentBall, nil];
    } else {
        [self.pottedBalls addObject:pottedball];
    }
    
    NSString *labelScore = [NSString stringWithFormat:@"%d",self.breakScore];
    self.text = labelScore;
}



// used by ViewController

-(void)clearBreak:(UIImageView*) imageCueBall {
    breakScore = 0;
    [self.pottedBalls removeAllObjects];
    [self.pottedBallTimeStamps removeAllObjects];
    
    self.hidden = true;
    imageCueBall.hidden = true;
}




@end
