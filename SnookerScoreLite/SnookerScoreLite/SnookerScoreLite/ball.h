//
//  buttonBall.h
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ball : UIButton {
    int pottedPoints;
    int foulPoints;
    int potsInBreakCounter;
    int quantity;
    NSString *colour;
    NSString *imageNameSmall;
    NSString *imageNameLarge;
    NSString *timeStamp;
}

@property (assign) int pottedPoints;
@property (assign) int foulPoints;
@property (assign) int quantity;
@property (assign) int potsInBreakCounter;
@property (nonatomic) NSString *colour;
@property (nonatomic) NSString *imageNameSmall;
@property (nonatomic) NSString *imageNameLarge;
@property (nonatomic) NSString *timeStamp;

-(void)decreaseQty;
@end
