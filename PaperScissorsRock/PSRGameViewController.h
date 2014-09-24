//
//  PSRGameViewController.h
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSRUser.h"
@import CoreMotion;

@interface PSRGameViewController : UIViewController

@property NSString *username;
@property (nonatomic, strong) PSRUser *gameUser;

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

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userSelectionImageView;
@property (strong, nonatomic) IBOutlet UIButton *startAccelerometerPlayButton;

- (IBAction)startAccelerometerPlay:(id)sender;
/*** Accelerometer data ***/

@end
