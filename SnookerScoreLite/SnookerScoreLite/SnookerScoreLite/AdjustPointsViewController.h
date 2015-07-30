//
//  DeductPointsViewController.h
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdjustPointsViewController;

@protocol AdjustPointsDelegate <NSObject>
- (void)addItemViewController:(AdjustPointsViewController *)controller didPickDeduction:(int)selectedPoints;
- (void)addItemViewController:(AdjustPointsViewController *)controller didPickBallAdjust:(int)ballIndex;
@end

@interface AdjustPointsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <AdjustPointsDelegate> delegate;
@property (assign) int sumOfPlayerFouls;
@property (assign) int ballIndex;
@property (assign) int selectedValue;
@property (strong, nonatomic) NSString *playerName;
@property (assign) bool advancedCounting;
@end