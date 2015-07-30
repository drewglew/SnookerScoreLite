//
//  DeductPointsViewController.m
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "AdjustPointsViewController.h"
#import "ball.h"

@interface AdjustPointsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *PointsPicker;
@property (weak, nonatomic) IBOutlet UILabel *labelExplanation;

@property (weak, nonatomic) IBOutlet UILabel *ballCounter;

@property (weak, nonatomic) IBOutlet UIStepper *stepperBallAdjuster;
@property (weak, nonatomic) IBOutlet UILabel *labelPointsRemaining;

@property (weak, nonatomic) IBOutlet UIButton *ballImage;
@property (weak, nonatomic) IBOutlet UIButton *selectPlayerButton;

@property (weak, nonatomic) IBOutlet UIView *ballAdjustView;



@end

@implementation AdjustPointsViewController

@synthesize selectedValue;
@synthesize advancedCounting;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sumOfPlayerFouls == 0) {
        self.labelExplanation.text = [NSString stringWithFormat:@"%@ has not received any foul points from the other player in this frame.\nYou may increase this players score however.",self.playerName];
    } else {
    self.labelExplanation.text = [NSString stringWithFormat:@"%@ has a total of %d foul points awarded.\nYou may  deduct this amount from the score.\nAlternatively you can increase this score.",self.playerName,self.sumOfPlayerFouls];
    }
    
    if (self.advancedCounting) {
        self.ballAdjustView.hidden = false;
    } else {
        self.ballAdjustView.hidden = true;
    }
    
    self.stepperBallAdjuster.value = self.ballIndex;
    [self updateBallCounter];
    
    //TODO
    [self.selectPlayerButton  setTitle:[NSString stringWithFormat:@"Update %@'s Frame Score",self.playerName] forState:UIControlStateNormal];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (NSInteger)self.sumOfPlayerFouls + 1 + 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (long)row - self.sumOfPlayerFouls];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
   self.selectedValue = (int)row;
}

- (void)addItemViewController:(AdjustPointsViewController *)controller didPickDeduction:(int)selectedPoints {
}

- (void)addItemViewController:(AdjustPointsViewController *)controller didPickBallAdjust:(int)ballIndex {

}


- (IBAction)selectClicked:(id)sender {
    self.selectedValue = ( self.selectedValue - self.sumOfPlayerFouls);
    [self.delegate addItemViewController:self didPickDeduction:self.selectedValue];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ballAdjustorClicked:(id)sender {
    [self.delegate addItemViewController:self didPickBallAdjust:(int)self.stepperBallAdjuster.value ];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)updateBallCounter {
    int ballRedAmount=0;
    int ballColourIndex=0;
    
    NSString* ballImageName;
    if (self.stepperBallAdjuster.value > 6) {
        // its a red
        
        self.ballCounter.text =[NSString stringWithFormat:@"%.f",self.stepperBallAdjuster.value - 6.0];
        ballRedAmount = self.stepperBallAdjuster.value - 6.0;
        ballColourIndex = 1;
        //ballImageName = @"ball_largex_red01.png";
        ballImageName = @"red01";
        
    } else {
        self.ballCounter.text =@"1";
        // it's a colour
        // black is actually equal to 1 so to get black we must have 8 and subtract.
        ballColourIndex = 8 - self.stepperBallAdjuster.value;
        
        if (ballColourIndex == 2 ) {
            ballImageName = @"yellow02";
        } else if (ballColourIndex==3) {
            ballImageName = @"green03";
        } else if (ballColourIndex==4) {
            ballImageName = @"brown04";
        } else if (ballColourIndex==5) {
            ballImageName = @"blue05";
        } else if (ballColourIndex==6) {
            ballImageName = @"pink06";
        } else if (ballColourIndex==7) {
            ballImageName = @"black07";
        }
    }
    
    UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_500x500.png",ballImageName ]];
    [self.ballImage setImage:buttonImage forState:UIControlStateNormal];

    int pointsRemaining=0;

    for (int i = 7; i >= ballColourIndex; i--)
    {
        if (i==1) {
            pointsRemaining += (ballRedAmount * 8);
        } else {
            pointsRemaining += i;
        }
    }
    
    self.labelPointsRemaining.text = [NSString stringWithFormat:@"%d Points Remaining",pointsRemaining];
    if (pointsRemaining == 0) {
        self.ballImage.enabled = false;
        self.ballCounter.text = @"0";
    } else {
        self.ballImage.enabled = true;
        
    }
}


- (IBAction)stepperClicked:(id)sender {
    [self updateBallCounter];
}





@end
