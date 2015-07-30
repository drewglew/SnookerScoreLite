//
//  graphView.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//

#import "graphView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)


/* TODO next - created new array selectedFrameData that will for all likes and purposes contain the 
 source for the graph and other supporting items shown in the playerstats */


@implementation graphView
@synthesize frameData;
@synthesize selectedFrameData;
@synthesize visitBallCollection;
@synthesize matchFramePoints;
@synthesize potTimeStampCollection;
@synthesize visitPlayerIndex;
@synthesize visitIsFoul;
@synthesize scorePlayer1;
@synthesize scorePlayer2;
@synthesize currentBreakPlayer1;
@synthesize currentBreakPlayer2;
@synthesize visitNumberOfBalls;
@synthesize timeStamp;
@synthesize visitPoints;
@synthesize visitRef;
@synthesize visitId;
@synthesize printGraph;
@synthesize matchStatistics;
@synthesize numberOfFrames;
@synthesize matchMaxPoints;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

CGRect touchAreas[100];


-(void) setPrint :(BOOL) enabled{
    printGraph = enabled;
}

-(void) initFrameData {
if (!self.frameData) {
    //NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    self.frameData = [[NSMutableArray alloc] init];
    self.selectedFrameData = [[NSMutableArray alloc] init];
    self.matchFramePoints = [[NSMutableArray alloc] init];
}
}


-(void)initMatchData {
    
    [self.matchFramePoints removeAllObjects];
    self.matchMaxPoints=0;
    
    for (int frameIndex = 1; frameIndex <= self.numberOfFrames; frameIndex++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (frameIndex==self.numberOfFrames) {
            // add currentbreak to last frame if it exists
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :1 :frameIndex]+self.currentBreakPlayer1] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :2 :frameIndex]+self.currentBreakPlayer2] forKey:@"player2"];
        } else {
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :1 :frameIndex]] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :2 :frameIndex]] forKey:@"player2"];
        }
        
        if ([[data valueForKeyPath:@"player1"] intValue] > self.matchMaxPoints) {
            self.matchMaxPoints = [[data valueForKeyPath:@"player1"] intValue];
        }
        
        if ([[data valueForKeyPath:@"player2"] intValue] > self.matchMaxPoints) {
            self.matchMaxPoints = [[data valueForKeyPath:@"player2"] intValue];
        }
        [self.matchFramePoints addObject:data];
    }
    self.matchMaxPoints ++;
}




-(void)addFrameData:(int)frameIndex :(int)playerIndex :(int)points :(int)isfoul :(NSMutableArray*) breakTransaction :(int)matchTxId :(NSMutableArray*) breakTimeStampTransaction {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];

    [data setValue: [NSNumber numberWithInt:matchTxId] forKey:@"matchTxId"];
    [data setValue: rightNow forKey:@"endbreakdatestamp"];
    [data setValue: [NSNumber numberWithInt:frameIndex] forKey:@"frameindex"];
    [data setValue: [NSNumber numberWithInt:playerIndex] forKey:@"player"];
    [data setValue: [NSNumber numberWithInt:points] forKey:@"points"];
    [data setValue: [NSNumber numberWithInt:isfoul] forKey:@"isfoul"];
    [data setValue: [NSMutableArray arrayWithArray:breakTransaction] forKey:@"ballTransaction"];
    [data setValue: [NSMutableArray arrayWithArray:breakTimeStampTransaction] forKey:@"pottedBallTimeStamp"];
    [self.frameData addObject:data];
    
    //[NSKeyedArchiver archivedDataWithRootObject:self.frameData];

}

-(NSMutableArray*) getSelectedFrameData :(NSMutableArray*) singleFrameData :(int)frameIndex {
    NSMutableArray *selectedFrame = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *dataPoint in singleFrameData) {
    
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        if ([wantedFrame intValue] == frameIndex ) {
            [selectedFrame addObject:dataPoint];
        } else if ([wantedFrame intValue] > frameIndex) {
            break;
        }
    }
    return selectedFrame;
}


-(int)getHighestBreakAmountInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex {
    
    int highestBreak=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0 && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            int totalBreak = 0;
            for (ball *ball in ballCollection) {
                totalBreak+=ball.pottedPoints;
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return highestBreak;
}





-(int)getAmountOfBallsByColorPottedInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int) wantedBall {
    
    int totalPotsOfWantedBall=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0) {
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            int ballPoint;
            
            for (ball *ball in ballCollection) {
                ballPoint = ball.pottedPoints;
                if (ballPoint==wantedBall) {
                    totalPotsOfWantedBall ++;
                }
            }
            
        }
    }
    return totalPotsOfWantedBall;
}



-(int)getAmountOfBallsPottedInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex :(int)frameIndex {
    
    int totalBalls=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0 && (frameIndex == [wantedFrame intValue] || frameIndex == 0 )) {
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            totalBalls += ballCollection.count;
        }
    }
    return totalBalls;
}


-(NSString*) createResultsContent :(NSMutableArray*) singleFrameData :(NSString*) playerName1 :(NSString*) playerName2 {
    
    NSString *fileData = @"TxID,BreakEndDT,Frame,PlayerID,IsFoul,BallColor,Points,PotDT";
    
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedTxId = [dataPoint valueForKeyPath:@"matchTxId"];
        NSString *wantedDateStamp = [dataPoint valueForKeyPath:@"endbreakdatestamp"];
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
  
        NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
        ballCollection = [dataPoint valueForKey:@"ballTransaction"];
        
        NSMutableArray  *potDTCollection = [[NSMutableArray alloc] init];
        potDTCollection = [dataPoint valueForKey:@"pottedBallTimeStamp"];
        
        NSString *potTimeStamp;
        
        NSString *playerName;
        if([wantedPlayer intValue] == 1) {
            playerName = playerName1;
        } else {
            playerName = playerName2;
        }
        
        int potIndex = 0;
        
        for (ball *ball in ballCollection) {
            
            potTimeStamp = [potDTCollection objectAtIndex:(NSUInteger)potIndex];
            
            int ballPoint;
            if ([wantedType intValue]==1) {
                ballPoint = ball.foulPoints;
            } else {
                ballPoint = ball.pottedPoints;
            }
            
            fileData = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@,%@,%@,%d,%@",fileData, wantedTxId,wantedDateStamp,wantedFrame,playerName,wantedType,ball.colour,ballPoint,potTimeStamp];
            
            potIndex ++;
            
        }
        
    }
    return fileData;
}






-(int)getAmountOfVisitsInFrame:(NSMutableArray*) singleFrameData  :(int)playerIndex {
    
    int totalVisits=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0) {
            totalVisits ++;
        }
    }
    return totalVisits;
}

-(NSMutableDictionary *)getHighestBreakBallsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex {
    // This method returns a dictionary of the balls that were potted in the highest break
    // within the frame.
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableDictionary *balls;
    
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && [wantedType intValue] == 0  && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            int totalBreak = 0;
            for (ball *ball in ballCollection) {
                totalBreak+=ball.pottedPoints;
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = ballCollection;
                ballsInBreak = (int)balls.count;
            } else if (totalBreak == highestBreak && ballsInBreak > (int)ballCollection.count) {
                // save the combination that has the most pots in it.
                balls = ballCollection;
                ballsInBreak = (int)balls.count;
            }
        }
        
    }
    return balls;
}




-(int)getPointsInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex {
    // get the players total accumunated points in frame
    return [self getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :playerIndex :0 :0] + [self getPointsByTypeInFrame :(NSMutableArray*) singleFrameData :playerIndex :1 :0];
}





-(int)getPointsInASingleFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)frameIndex {
    return [self getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :playerIndex :0 :frameIndex] + [self getPointsByTypeInFrame :(NSMutableArray*) singleFrameData :playerIndex :1 :frameIndex];
    
}

-(int)getPointsByTypeInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex :(int)isfoul :(int)frameIndex {
    // This method is used to obtain either the potted points a player has made or the foul points a
    // player has received.
    
    int retValue=0;
    for (NSMutableArray *dataPoint in singleFrameData) {
        
        NSNumber *wantedPlayer = [dataPoint valueForKeyPath:@"player"];
        NSNumber *wantedType = [dataPoint valueForKeyPath:@"isfoul"];
        NSNumber *wantedFrame = [dataPoint valueForKeyPath:@"frameindex"];
        
        if (playerIndex == [wantedPlayer intValue] && isfoul == [wantedType intValue] && (frameIndex == [wantedFrame intValue] || frameIndex == 0)) {
            
            NSMutableDictionary *ballCollection = [[NSMutableDictionary alloc] init];
            ballCollection = [dataPoint valueForKey:@"ballTransaction"];
            
            // this can be replaced by getBreakAmountFromBalls()
            for (ball *ball in ballCollection) {
                if (isfoul ==0) {
                    retValue+=ball.pottedPoints;
                } else {
                    retValue+=ball.foulPoints;
                }
            }
            
        }
        
    }
    return retValue;
}





/* --------- */

-(NSString *)getTotalFrameTime:(NSMutableArray*) frameStartDates :(int) frameIndex {

    NSString *firstEntry;
    NSString *lastEntry;
    
    if (frameStartDates.count==0) {
        return @"00:00";
    }
   
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    if (frameIndex==0) {
        firstEntry = [NSString stringWithFormat:@"%@", [frameStartDates objectAtIndex:0]];
        lastEntry = [dateFormatter stringFromDate:[NSDate date]];
    } else {
    
        firstEntry = [NSString stringWithFormat:@"%@", [frameStartDates objectAtIndex:frameIndex-1]];
    
        if (frameIndex == frameStartDates.count) {
            lastEntry = [dateFormatter stringFromDate:[NSDate date]];
        } else {
            lastEntry = [NSString stringWithFormat:@"%@", [frameStartDates objectAtIndex:frameIndex]];
        }
    
    }
        
    NSDate *dateFirstEntry = [[NSDate alloc] init];
    NSDate *dateLastEntry = [[NSDate alloc] init];
    // voila!
    dateFirstEntry = [dateFormatter dateFromString:firstEntry];
    dateLastEntry = [dateFormatter dateFromString:lastEntry];
                 
    NSTimeInterval interval = [dateLastEntry timeIntervalSinceDate:dateFirstEntry];

    return [self stringFromTimeInterval :interval];

}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}



-(float)getAverageBreakAmountInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    
    totalPottedPoints = [self getPointsByTypeInFrame:singleFrameData :playerIndex :0 :0];
    
    totalVisits = [self getAmountOfVisitsInFrame:singleFrameData :playerIndex];
    
    float avgAmount = 0.0;
    
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    
    return avgAmount;
}


-(float)getSSMStatInFrame:(NSMutableArray*) singleFrameData :(int)playerIndex {
    int totalPottedPoints = 0;
    int totalPots = 0;
    
    totalPottedPoints = [self getPointsByTypeInFrame:singleFrameData :playerIndex :0 :0];
    totalPots = [self getAmountOfBallsPottedInFrame:singleFrameData :playerIndex :0];
    
    float avgAmount = 0.0;
    
    //there is a total number of points (including active break) that current player has potted already.
    //to add there are a total number of balls remaining on the table.
    
    //int nbrOfReds = [self getAmountOfBallsByColorPottedInFrame :singleFrameData :1 :1] +
    //[self getAmountOfBallsByColorPottedInFrame :singleFrameData :2 :1]
    //;
    
    
    
    
    // so player has 10 points + 16 in active break
    // there are actually only 5 reds and all the colours left, give max points possibly scored (this must be passed)
    // 8*10 = 80
    // (26/80) * 100 is the value needed!
    
    // challenge is when getting stats for whole match.
    
    
    
    avgAmount = (float)totalPottedPoints/(float)totalPots;
    
    //avgAmount = ((float)totalPottedPoints / 147.0f) * 100;
    
    if isnan(avgAmount) {
        avgAmount=0.0;
    } else {
        avgAmount = (avgAmount / 4.08f) * 100;
        if (avgAmount > 100.0f) {
            avgAmount = 100.0f;
        }
        
    }

    
    
    
    
    return avgAmount;
}


-(int)getBreakAmountFromBalls:(NSMutableArray*)balls :(NSNumber *)isfoul {
    int breakAmount = 0;
    
    for (ball *ball in balls) {
        if ([isfoul intValue] == 0) {
            breakAmount+=ball.pottedPoints;
        } else {
            breakAmount+=ball.foulPoints;
        }
    }
    return breakAmount;
}





-(void)resetFrameData {
    [self.frameData removeAllObjects];
    self.scorePlayer1=0;
    self.scorePlayer2=0;
}


-(void)plotPlayerLines:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(int) breakOfPlayer  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0; // incremental index to plot
    
    float plotVisitsX=0.0f;
    float plotPointsY=0.0f + graphHeight;
    CGGradientRef gradient = NULL;
    CGColorSpaceRef colorspace;
    CGPoint startPoint, endPoint;
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    
    if (fillGraph) {

        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        if (playerIndex == 2) {
            CGFloat components[8] = {209.0f/255.0f, 0.0, 0.0, 0.1,  // Start color
                209.0f/255.0f, 0.0, 0.0, 0.9}; // End color
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        } else {
            
            //[UIColor colorWithRed:29.0f/255.0f green:148.0f/255.0f blue:14.0f/255.0f alpha:1.0f]
            
            CGFloat components[8] = {0.0f/255.0f, 0.0f/255.0f, 205.0f/255.0f, 0.1,  // Start color
                0.0f/255.0f, 0.0f/255.0f, 205.0f/255.0f, 0.9}; // End color
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        }
        startPoint.x = kOffsetX;
        startPoint.y = maxGraphHeight;
        endPoint.x = kOffsetX;
        endPoint.y = kOffsetY;
    }
    
    /* first part is to draw the lines of data actually logged */
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (NSMutableArray *dataPoint in self.selectedFrameData) {
        dataIndex ++;
        NSNumber *scoreNbr=[dataPoint valueForKeyPath:@"player"];
        int pIndex = [scoreNbr intValue];
        
        if (pIndex == playerIndex) {
            
            NSNumber *pointsValue=[dataPoint valueForKeyPath:@"points"];
            score += [pointsValue intValue];
            
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
        }
        
    }
    if (fillGraph) {
        
        CGContextAddLineToPoint(ctx, plotVisitsX, maxGraphHeight);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGColorSpaceRelease(colorspace);
        CGGradientRelease(gradient);
        
    } else {
        
        CGContextDrawPath(ctx, kCGPathStroke);
    
        /* last part of method is to check if selected player has a break that is current or not */
        if (breakOfPlayer > 0) {
            /* break exists, draw one dotted line entry to signify entry on graph */
            CGContextSetLineWidth(ctx, 2.0);
            CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
            /* turn dash on! */
            CGFloat dash[] = {5.0, 5.0};
            CGContextSetLineDash(ctx, 0.0, dash, 2);
        
            dataIndex ++;
            score += breakOfPlayer;
        
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
            CGContextDrawPath(ctx, kCGPathStroke);
            /* remove dash */
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
}






-(void)plotPlayerMarkers:(CGContextRef)ctx :(int) playerIndex  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotVisitsX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    int score=0; // variable used to store visit point value.
    int dataIndex = 0;
    for (NSMutableArray *dataPoint in self.selectedFrameData) {
        dataIndex ++;
        NSNumber *pointsValue=[dataPoint valueForKeyPath:@"player"];
        int pIndex = [pointsValue intValue];
    
        if (pIndex == playerIndex) {
        
            NSLog(@"%@",[dataPoint valueForKey:@"ballTransaction"]);
            
            NSNumber *pointsValue=[dataPoint valueForKeyPath:@"points"];
            score += [pointsValue intValue];
        
            float plotPoints = scalePointsY * score;
        
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGRect rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            
            if (dataIndex<100) {
                touchAreas[dataIndex] = rect;
            }
            CGContextAddEllipseInRect(ctx, rect);
        }
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //NSLog(@"Touch x:%f, y:%f", point.x, point.y);
    for (int i = 0; i < 100; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            
            if (self.matchStatistics) {
                [self updateStatBox:i :TRUE];
            } else {
                [self loadVisitWindow:i :TRUE];
            }
            break;
        }
    }
}


-(void) updateStatBox:(int) pointerIndex :(BOOL) fromGraph {

 
    int realPointer=pointerIndex;

    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];;
    int pointsPlayer1;
    int pointsPlayer2;
    int playerIndex;
 
    if (pointerIndex > self.numberOfFrames) {
        realPointer -= (self.numberOfFrames + 1);
        data = [self.matchFramePoints objectAtIndex:realPointer];
        playerIndex = 2;
        realPointer++;
    } else {
        data = [self.matchFramePoints objectAtIndex:realPointer-1];
        playerIndex = 1;
    }
    pointsPlayer1 = [[data valueForKeyPath:@"player1"] intValue];
    pointsPlayer2 = [[data valueForKeyPath:@"player2"] intValue];

    
 
    [self.delegate displayMatchPoint :pointsPlayer1 :pointsPlayer2 :playerIndex :realPointer];
    
    
    
    //need to delegate update of box
    NSLog(@"Tapped a match stat with index %d, value", pointerIndex);
}




-(void) loadVisitWindow:(int) visitIndex :(BOOL) fromGraph {
    // example.  need to obtain items ball count..
    
    int index = visitIndex;
    if (self.selectedFrameData.count < visitIndex) {
        index = (int)self.selectedFrameData.count;
    }
    
    NSMutableArray *data = [self.selectedFrameData objectAtIndex:index-1];
    self.visitBallCollection = [data valueForKey:@"ballTransaction"];
    self.potTimeStampCollection = [data valueForKey:@"pottedBallTimeStamp"];
    self.visitNumberOfBalls = self.visitBallCollection.count;
    self.visitPlayerIndex = [data valueForKey:@"player"];
    
    self.visitIsFoul = [data valueForKey:@"isfoul"];
    self.timeStamp = [data valueForKey:@"endbreakdatestamp"];
    self.visitPoints = [data valueForKey:@"points"];

    self.visitRef = [NSString stringWithFormat:@"%d/%d",index,(int)self.selectedFrameData.count];
    self.visitId = index;

    if (fromGraph) {
        [self.delegate reloadGrid];
        self.visitBreakDown.hidden = false;
    }
    NSLog(@"Tapped a bar with index %d, value", index);
}



- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    /* assist with scale of graph - height */
    int maxScore;
    if (self.scorePlayer1+self.currentBreakPlayer1 > self.scorePlayer2+self.currentBreakPlayer2) {
        maxScore = self.scorePlayer1+1+self.currentBreakPlayer1;
    } else {
        maxScore = self.scorePlayer2+1+self.currentBreakPlayer2;
    }
    float scalePoints = 1.0f/maxScore;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.selectedFrameData.count;
    if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
        frameDataEntries ++;
    }
    float scaleVisits=0.0;
    if (frameDataEntries>0) {
        scaleVisits = ((int)self.frame.size.width - 5) / frameDataEntries;
    }
    /* Player 1 plotting */
    [self plotPlayerLines:false :ctx :1 :self.currentBreakPlayer1 :[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :1 :self.currentBreakPlayer1 :[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerMarkers:ctx :1 :[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    /* Player 2 plotting */
    [self plotPlayerLines:false :ctx :2 :self.currentBreakPlayer2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :2 :self.currentBreakPlayer2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerMarkers:ctx :2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
}





- (void)drawMatchLineGraphWithContext:(CGContextRef)ctx
{
    /* assist with scale of graph - height */
    /*
    NSMutableArray *matchPoints = [[NSMutableArray alloc] init];

    int maxScore=0;
    
    for (int frameIndex = 1; frameIndex <= self.numberOfFrames; frameIndex++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (frameIndex==self.numberOfFrames) {
            // add currentbreak to last frame if it exists
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :1 :frameIndex]+self.currentBreakPlayer1] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :2 :frameIndex]+self.currentBreakPlayer2] forKey:@"player2"];
        } else {
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :1 :frameIndex]] forKey:@"player1"];
         
            [data setValue:[NSNumber numberWithInt:[self getPointsInASingleFrame:[self selectedFrameData] :2 :frameIndex]] forKey:@"player2"];
        }
        
        if ([[data valueForKeyPath:@"player1"] intValue] > maxScore) {
            maxScore = [[data valueForKeyPath:@"player1"] intValue];
        }

        if ([[data valueForKeyPath:@"player2"] intValue] > maxScore) {
            maxScore = [[data valueForKeyPath:@"player2"] intValue];
        }
        [matchPoints addObject:data];
    }
    
    maxScore ++;
*/
    float scalePoints = 1.0f/self.matchMaxPoints;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.matchFramePoints.count;


    float scaleFrames=0.0;
    if (frameDataEntries>0) {
        scaleFrames = ((int)self.frame.size.width - 5) / frameDataEntries;
    }
    
    
    // Player 1 plotting
    [self plotMatchPlayerLines:false :ctx :1 :self.matchFramePoints :[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames];
    /*
     
    [self plotPlayerLines:true :ctx :1 :self.currentBreakPlayer1 :[UIColor colorWithRed:29.0f/255.0f green:100.0f/255.0f blue:14.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    */
    
    int touchIndex = 0;
    
    touchIndex = [self plotMatchPlayerMarkers:ctx :self.matchFramePoints :1 :[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames :touchIndex];

    
    // Player 2 plotting
    [self plotMatchPlayerLines:false :ctx :2 :self.matchFramePoints :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames];
    /*
    [self plotPlayerLines:true :ctx :2 :self.currentBreakPlayer2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    
    */
    touchIndex = [self plotMatchPlayerMarkers:ctx :self.matchFramePoints :2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames :touchIndex];
    
}


-(int)plotMatchPlayerMarkers:(CGContextRef)ctx :(NSMutableArray*) matchData :(int) playerIndex  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleFramesX :(int)touchIndex {
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    int columnX = 0;
    int touchID = touchIndex;
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotFramesX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    int score=0; // variable used to store visit point value.
    for (NSMutableArray *dataPoint in matchData) {
        columnX ++;
        touchID++;
        NSNumber *pointsValue;
        if (playerIndex==1) {
            pointsValue=[dataPoint valueForKeyPath:@"player1"];
        } else {
            pointsValue=[dataPoint valueForKeyPath:@"player2"];
        }
    
        score = [pointsValue intValue];
            
        float plotPoints = scalePointsY * score;
            
        plotFramesX = kOffsetX + columnX * scaleFramesX;
        plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            
        CGRect rect = CGRectMake(plotFramesX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            
        if (touchID<100) {
            touchAreas[touchID] = rect;
        }
        CGContextAddEllipseInRect(ctx, rect);
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    return touchID;
}





-(void)plotMatchPlayerLines:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(NSMutableArray*) matchData  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleFramesX {
    
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    //CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0; // incremental index to plot
    
    float plotFramesX=0.0f;
    float plotPointsY=0.0f + graphHeight;

    CGColorSpaceRef colorspace;

    colorspace = CGColorSpaceCreateDeviceRGB();
 
    /* first part is to draw the lines of data actually logged */
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, plotFramesX, plotPointsY);
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (NSMutableArray *dataPoint in matchData) {
        dataIndex ++;
        
        NSNumber *pointsValue;
        if (playerIndex==1) {
            pointsValue=[dataPoint valueForKeyPath:@"player1"];
        } else {
            pointsValue=[dataPoint valueForKeyPath:@"player2"];
        }
        
        score = [pointsValue intValue];
        
        float plotPoints = scalePointsY * score;
        plotFramesX = kOffsetX + dataIndex * scaleFramesX;
        plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        CGContextAddLineToPoint(ctx, plotFramesX ,plotPointsY );
        
        
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
}






//TODO scale the amount of lines drawn with the dynamic resized graph

- (void)drawRect:(CGRect)rect {
    
    if (self.printGraph) {
        [self initMatchData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
 
    CGFloat dash[] = {1.0, 1.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int graphBottom = self.frame.size.height;
    
    
    if (self.matchStatistics == false) {
    
        NSUInteger frameDataEntries = self.selectedFrameData.count;
        if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
            frameDataEntries ++;
        }

        float scaleVisits = 0.0;
        if (frameDataEntries>0) {
            scaleVisits = ((int)self.frame.size.width - 5) / frameDataEntries;
        }
    
        if (scaleVisits==0) {
            scaleVisits=50;
        }

    
        // How many lines?
        int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleVisits;
    
        // Here the lines go
        for (int i = 0; i < howMany; i++)
        {
            CGContextMoveToPoint(context, kOffsetX + i * scaleVisits, kGraphTop);
            CGContextAddLineToPoint(context, kOffsetX + i * scaleVisits, graphBottom);
        }
    
        int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleVisits;
        for (int i = 0; i <= howManyHorizontal; i++)
        {
            CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleVisits);
            CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleVisits    );
        }
    
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
        [self drawLineGraphWithContext:context];

    } else {
        // do match statistic data!

        float scaleFrames = 0.0;
        if (self.numberOfFrames>0) {
            scaleFrames = ((int)self.frame.size.width - 5) / self.numberOfFrames;
        }
        
        if (scaleFrames==0) {
            scaleFrames=10;
        }
        
        // How many lines?
        int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleFrames;
        
        // Here the lines go
        for (int i = 0; i < howMany; i++)
        {
            CGContextMoveToPoint(context, kOffsetX + i * scaleFrames, kGraphTop);
            CGContextAddLineToPoint(context, kOffsetX + i * scaleFrames, graphBottom);
        }

        
        int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleFrames;
        for (int i = 0; i <= howManyHorizontal; i++)
        {
            CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleFrames);
            CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleFrames    );
        }

        
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
        [self drawMatchLineGraphWithContext:context];
        
        //self.graphPNG = [self imageWithView :self];
    }
    
}

- (UIImage *) imageWithView:(graphView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}





@end
