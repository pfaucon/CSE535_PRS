//
//  PSRGameViewController.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRGameViewController.h"
#import "PSRGame.h"

#define kGameTime 3
#define kUpdateFrequency 60.0

@interface PSRGameViewController ()
{
    NSTimer *timer;
    int currSec;
    
    double x;
    double y;
    double z;
}

@property (weak, nonatomic) IBOutlet UILabel *opponentsChoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratulationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property PSRGame *game;
@end

@implementation PSRGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.opponentsChoiceLabel.text = @"";
    self.scoreLabel.text = @"";
    self.congratulationsLabel.hidden = YES;
    self.game = [PSRGame new];
    self.game.gameUser = self.gameUser;
    
    /*** Accelerometer initialization ***/
    self.currentMaxAccelX = 0;
    self.currentMaxAccelY = 0;
    self.currentMaxAccelZ = 0;
    
    self.currentMinAccelX = 0;
    self.currentMinAccelY = 0;
    self.currentMinAccelZ = 0;
    
    x = 0;
    y = 0;
    z = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1.0 / kUpdateFrequency;
    /*** Accelerometer initialization ***/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.usernameLabel.text = [NSString stringWithFormat:@"Welcome %@!",self.gameUser.username];
    [self updateRecordLabel];
}

- (void)updateRecordLabel
{
    self.recordLabel.text = [NSString stringWithFormat:@"Record: %ldW - %ldL",self.gameUser.winCnt, self.gameUser.lossCnt];
}

- (IBAction)chooseRock:(id)sender {
    [self submitChoice:ROCK];
}
- (IBAction)choosePaper:(id)sender {
    [self submitChoice:PAPER];
}
- (IBAction)chooseScissors:(id)sender {
    [self submitChoice:SCISSORS];
}

-(void)submitChoice:(PSRACTION) choice
{
    WINCONDITION outcome = [self.game playerWonBySubmitting:choice];
    self.userSelectionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", PSRActionString(choice)]];
    if(outcome == WIN)
    {
        self.congratulationsLabel.hidden = NO;
    }
    else
    {
        self.congratulationsLabel.hidden = YES;
    }
    
    self.opponentsChoiceLabel.text = [NSString stringWithFormat:@"The Computer Picked: %@", PSRActionString(self.game.opponentsLastChoice)];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    
    [self updateRecordLabel];
}

/*** Accelerometer functions ***/
- (IBAction)startAccelerometerPlay:(id)sender {
    self.congratulationsLabel.hidden = YES;
    self.opponentsChoiceLabel.text = @"";
    
    [self.startAccelerometerPlayButton setTitle:@"Restart" forState:UIControlStateNormal];
    self.userSelectionImageView.image = nil;
    
    currSec = kGameTime;
    self.currentMaxAccelX = 0;
    self.currentMaxAccelY = 0;
    self.currentMaxAccelZ = 0;
    
    self.currentMinAccelX = 0;
    self.currentMinAccelY = 0;
    self.currentMinAccelZ = 0;
    
    [timer invalidate];
    [self stopAccelerometer];
    [self startAccelerometer];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d", currSec];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired
{
    if(currSec <= kGameTime && currSec >= 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%d", currSec];
        currSec -= 1;
    }
    
    else
    {
        self.timeLabel.text = @"Time is up";
        [self.startAccelerometerPlayButton setTitle:@"Play using accelerometer" forState:UIControlStateNormal];
        
        [timer invalidate];
        [self stopAccelerometer];
        
        double XYMinDiff = (self.currentMinAccelX - self.currentMinAccelY) * -1;
        double XYMaxDiff = (self.currentMaxAccelX - self.currentMaxAccelY) * -1;
        double YZMaxDiff = (self.currentMaxAccelY - self.currentMaxAccelZ) * -1;
        
        // Logic for determining the choice that user selected.
        if(self.currentMinAccelZ < -1.2 && YZMaxDiff < 0.6)
        {
            [self submitChoice:PAPER];
        }
        
        else if(XYMinDiff >= 0.5 && (XYMaxDiff >= -0.5 && XYMaxDiff <= 0.5))
        {
            [self submitChoice:SCISSORS];
        }
        
        else if(XYMinDiff < 0.5 && self.currentMinAccelY < -1)
        {
            [self submitChoice:ROCK];
        }
        
        else
        {
            NSLog(@"Not Recognized");
        }
    }
}

- (void)startAccelerometer
{
    // Calculating required values for low pass filtering
    double dt = 1.0 / kUpdateFrequency;
    double RC = 1.0 / 5.0;
    double alpha = dt / (dt + RC);
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 
                                                 // Doing low pass filtering
                                                 x = accelerometerData.acceleration.x * alpha + x * (1.0 - alpha);
                                                 y = accelerometerData.acceleration.y * alpha + y * (1.0 - alpha);
                                                 z = accelerometerData.acceleration.z * alpha + z * (1.0 - alpha);
                                                 
                                                 // Finding the min and max for X, Y, Z axis.
                                                 if(self.currentMaxAccelX < x)
                                                 {
                                                     self.currentMaxAccelX = x;
                                                 }
                                                 
                                                 if(self.currentMinAccelX > x)
                                                 {
                                                     self.currentMinAccelX = x;
                                                 }
                                                 
                                                 if(self.currentMaxAccelY < y)
                                                 {
                                                     self.currentMaxAccelY = y;
                                                 }
                                                 
                                                 if(self.currentMinAccelY > y)
                                                 {
                                                     self.currentMinAccelY = y;
                                                 }
                                                 
                                                 if(self.currentMaxAccelZ < z)
                                                 {
                                                     self.currentMaxAccelZ = z;
                                                 }
                                                 
                                                 if(self.currentMinAccelZ > z)
                                                 {
                                                     self.currentMinAccelZ = z;
                                                 }
                                                 
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
}

- (void)stopAccelerometer
{
    [self.motionManager stopAccelerometerUpdates];
}
/*** Accelerometer functions ***/
@end
