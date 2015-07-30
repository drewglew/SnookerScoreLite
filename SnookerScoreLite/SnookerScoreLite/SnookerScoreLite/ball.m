//
//  buttonBall.m
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "ball.h"

@implementation ball

@synthesize pottedPoints;
@synthesize foulPoints;
@synthesize quantity;
@synthesize colour;
@synthesize imageNameSmall;
@synthesize potsInBreakCounter;
@synthesize timeStamp;

-(id)init {
    if (self = [super init])  {
        self.foulPoints = 4;
        self.quantity = 1;
    }
    return self;
}

-(int)pottedPoints {
    return pottedPoints;
}

-(void)setPottedPoints:(int) value {
    pottedPoints = value;
}

-(int)potsInBreakCounter {
    return potsInBreakCounter;
}

-(void)setPotsInBreakCounter:(int) value {
    potsInBreakCounter = value;
}

-(int)foulPoints {
    return foulPoints;
}

-(void)setFoulPoints:(int) value {
    foulPoints = value;
}

-(NSString *)colour {
    return colour;
}

-(void)setColour:(NSString *) value {
    colour = value;
}

-(NSString *)imageNameSmall {
    return imageNameSmall;
}

-(void)setImageNameSmall:(NSString *) value {
    imageNameSmall = value;
}

-(NSString *)imageNameLarge {
    return imageNameLarge;
}

-(void)setImageNameLarge:(NSString *) value {
    imageNameLarge = value;
}


-(int)quantity {
    return quantity;
}

-(void)setQuantity:(int) value {
    quantity = value;
}

-(void)decreaseQty {
    //if ([self.colour  isEqual: @"red"]) {
    //}
    
    
    quantity--;
    if (quantity == 0) {
       // self.hidden = true;
        self.enabled = false;
    }
}


- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
    [self setAlpha:0.4];
    } else {
    [self setAlpha:1.0];
    }
}



@end
