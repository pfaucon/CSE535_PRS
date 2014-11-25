//
//  PSRBLGameViewController.h
//  PaperScissorsRock
//
//  Created by John Yu on 11/22/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSRUser.h"
#import "PSRAppDelegate.h"

@import MultipeerConnectivity;
@import CoreMotion;

@interface PSRBLGameViewController : UIViewController

@property NSString *username;
@property (nonatomic, strong) PSRUser *gameUser;

- (IBAction)disconnectPressed:(id)sender;
@property (nonatomic, strong) PSRAppDelegate *appDelegate;
@property (nonatomic) PSRACTION opponentChoice;
@property (nonatomic) PSRACTION userChoice; // -1: choice has not been made
@property (strong, nonatomic) IBOutlet UILabel *gameTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *opponentLabel;

/*** Accelerometer data ***/
@property (nonatomic) double currentMaxAccelX;
@property (nonatomic) double currentMaxAccelY;
@property (nonatomic) double currentMaxAccelZ;

@property (nonatomic) double currentMinAccelX;
@property (nonatomic) double currentMinAccelY;
@property (nonatomic) double currentMinAccelZ;

@property (nonatomic) double currentMaxRotX;
@property (nonatomic) double currentMaxRotY;
@property (nonatomic) double currentMaxRotZ;

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet UILabel *accelerometerTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *opponentsSelectionImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userSelectionImageView;
@property (strong, nonatomic) IBOutlet UIButton *startAccelerometerPlayButton;

- (IBAction)startAccelerometerPlay:(id)sender;
/*** Accelerometer data ***/

//Drawing data
@property (strong, nonatomic) IBOutlet UIView *drawUI;

@end
