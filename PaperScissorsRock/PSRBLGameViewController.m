//
//  PSRBLGameViewController.m
//  PaperScissorsRock
//
//  Created by John Yu on 11/22/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRBLGameViewController.h"
#import "PSRGame.h"
#import "MGlyphDetectorView.h"

#define kAccelerometerTime 2
#define kGameTime 3
#define kUpdateFrequency 60.0
#define GESTURE_SCORE_THRESHOLD 1.2f

@interface PSRBLGameViewController ()
{
    NSTimer *accelerometerTimer;
    int currAccSec;
    
    double x;
    double y;
    double z;
    
    int currGameSec;
    NSTimer *playAgainViewTimer;
    int currPlayAgainSec;
}

@property (weak, nonatomic) IBOutlet UILabel *congratulationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (strong, nonatomic) MGlyphDetectorView *gestureDetectorView;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property PSRGame *game;
@property (nonatomic) NSTimer *gameTimer;

@property (nonatomic) UIView *playAgainView;
@end

@implementation PSRBLGameViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveStateChangeWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    // Do any additional setup after loading the view.
    self.appDelegate = (PSRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.congratulationsLabel.hidden = YES;
    self.game = [PSRGame new];
    self.game.gameUser = self.gameUser;
    self.opponentLabel.text = [[self.appDelegate.mcManager.session.connectedPeers objectAtIndex:0] displayName];
    
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
    self.motionManager.accelerometerUpdateInterval = .1 / kUpdateFrequency;
    /*** Accelerometer initialization ***/
    
    /*** Gesture initialization ***/
    self.drawUI.layer.borderColor = [UIColor blueColor].CGColor;
    self.drawUI.layer.borderWidth = 2;
    self.drawUI.layer.cornerRadius = 10;
    self.drawUI.layer.masksToBounds = YES;
    self.gestureDetectorView = [[MGlyphDetectorView alloc] initWithFrame:self.drawUI.bounds];
    self.gestureDetectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gestureDetectorView.delegate = self;
    [self.gestureDetectorView loadTemplatesWithNames:@"R",@"P",@"S",@"LV",@"LH", nil];
    [self.drawUI addSubview:self.gestureDetectorView];
    /*** Gesture initialization ***/
}

////TODO
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    NSString *glyphNames = [self.gestureDetectorView getGlyphNamesString];
////    if([glyphNames length] > 0)
////    {
////        NSString *statusText = [NSString stringWithFormat:@"Loaded with %@ templates.\n\nStart drawing.", [self.gestureDetectorView getGlyphNamesString]];
////        self.lblStatus.text = statusText;
////    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.usernameLabel.text = [NSString stringWithFormat:@"Welcome %@!",self.gameUser.username];
    [self updateRecordLabel];
    self.userChoice = NOCHOICE;
}

- (void)updateRecordLabel
{
    self.recordLabel.text = [NSString stringWithFormat:@"Record: %ldW - %ldL",(unsigned long)self.gameUser.winCnt, (unsigned long)self.gameUser.lossCnt];
}

- (IBAction)chooseRock:(id)sender {
    [self sendChoice:ROCK];
}
- (IBAction)choosePaper:(id)sender {
    [self sendChoice:PAPER];
}
- (IBAction)chooseScissors:(id)sender {
    [self sendChoice:SCISSORS];
}

-(void)submitChoice:(PSRACTION) choice
{
    WINCONDITION outcome = [self.game bluetoothPlayPlayerOneChoice:choice playerTwoChoice:self.opponentChoice];
    self.userSelectionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", PSRActionString(choice)]];
    if(outcome == WIN)
    {
        self.congratulationsLabel.hidden = NO;
    }
    else
    {
        self.congratulationsLabel.hidden = YES;
    }
    
    self.opponentsSelectionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ Black.png", PSRActionString(self.game.opponentsLastChoice)]];
    
    [self updateRecordLabel];
    self.userChoice = NOCHOICE;
    currGameSec = kGameTime;
    
    currPlayAgainSec = 1;
    playAgainViewTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playAgainViewTimerFired) userInfo:nil repeats:YES];
}

- (void)playAgainViewTimerFired
{
    if(currPlayAgainSec <= kGameTime && currPlayAgainSec >= 0)
    {
        currPlayAgainSec -= 1;
    }
    
    else
    {
        [self showPlayAgainView];
        [playAgainViewTimer invalidate];
    }
}

/*** Accelerometer functions ***/
- (IBAction)startAccelerometerPlay:(id)sender {
    self.congratulationsLabel.hidden = YES;
    
    
    [self.startAccelerometerPlayButton setTitle:@"Restart" forState:UIControlStateNormal];
    self.userSelectionImageView.image = nil;
    self.opponentsSelectionImageView.image = nil;
    
    currAccSec = kAccelerometerTime;
    self.currentMaxAccelX = 0;
    self.currentMaxAccelY = 0;
    self.currentMaxAccelZ = 0;
    
    self.currentMinAccelX = 0;
    self.currentMinAccelY = 0;
    self.currentMinAccelZ = 0;
    
    [accelerometerTimer invalidate];
    [self stopAccelerometer];
    [self startAccelerometer];
    
    self.accelerometerTimeLabel.text = [NSString stringWithFormat:@"%d", currAccSec];
    accelerometerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(accelerometerTimerFired) userInfo:nil repeats:YES];
}

- (void)accelerometerTimerFired
{
    if(currAccSec <= kAccelerometerTime && currAccSec >= 0)
    {
        self.accelerometerTimeLabel.text = [NSString stringWithFormat:@"%d", currAccSec];
        currAccSec -= 1;
    }
    
    else
    {
        self.accelerometerTimeLabel.text = @"Time is up";
        [self.startAccelerometerPlayButton setTitle:@"Play using accelerometer" forState:UIControlStateNormal];
        
        [accelerometerTimer invalidate];
        [self stopAccelerometer];
        
        double XYMinDiff = (self.currentMinAccelX - self.currentMinAccelY) * -1;
        double XYMaxDiff = (self.currentMaxAccelX - self.currentMaxAccelY) * -1;
        double YZMaxDiff = (self.currentMaxAccelY - self.currentMaxAccelZ) * -1;
        
        // Logic for determining the choice that user selected.
        if(self.currentMinAccelZ < -1.2 && YZMaxDiff < 0.6)
        {
            [self sendChoice:PAPER];
        }
        
        else if(XYMinDiff >= 0.5 && (XYMaxDiff >= -0.5 && XYMaxDiff <= 0.5))
        {
            [self sendChoice:SCISSORS];
        }
        
        else if(XYMinDiff < 0.5 && self.currentMinAccelY < -1)
        {
            [self sendChoice:ROCK];
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

/*** Gesture functions ***/
-(void)viewDidUnload
{
    [self.gestureDetectorView removeFromSuperview];
    self.gestureDetectorView.delegate = nil;
    self.gestureDetectorView = nil;
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)wtmGlyphDetectorView:(MGlyphDetectorView*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    if (score < GESTURE_SCORE_THRESHOLD)
        return;
    //    NSString *statusString = @"";
    
    //NSString *glyphNames = [self.gestureDetectorView getGlyphNamesString];
    //if([glyphNames length] > 0)
    //statusString = [statusString stringByAppendingFormat:@"Loaded 1`2with %@ templates.\n", glyphNames];
    
    //statusString = [statusString stringByAppendingFormat:@"Last gesture detected: %@\nScore: %.3f", glyph.name, score];
    
    if ([glyph.name isEqualToString:@"S"]) {
        [self sendChoice:SCISSORS];
    }
    else if ([glyph.name isEqualToString:@"R"])
    {
        [self sendChoice:ROCK];
    }
    else if ([glyph.name isEqualToString:@"P"])
    {
        [self sendChoice:PAPER];
    }
    
    //self.lblStatus.text = glyph.name;
}

/*** Gesture functions ***/

-(void)didReceiveStateChangeWithNotification:(NSNotification *)notification{
    NSNumber *currentState = [[notification userInfo] objectForKey:@"state"];
    if(MCSessionStateNotConnected == currentState.integerValue)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
    
}
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSDictionary *dicData = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    
    if(dicData[@"choice"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.opponentChoice = [dicData[@"choice"] integerValue];
            
            if(self.userChoice == NOCHOICE)
            {
                currGameSec = kGameTime;
                self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameTimerFired) userInfo:nil repeats:YES];
            }
            
            else
            {
                [self submitChoice:self.userChoice];
            }
        });
        
    }
}

- (void)gameTimerFired
{
    if(currGameSec <= kGameTime && currGameSec >= 0)
    {
        if(self.userChoice != NOCHOICE)
        {
            [self.gameTimer invalidate];
            [self submitChoice:self.userChoice];
        }
        self.gameTimeLabel.text = [NSString stringWithFormat:@"%d", currGameSec];
        currGameSec -= 1;
    }
    
    else
    {
        self.gameTimeLabel.text = [NSString stringWithFormat:@"%d", currGameSec];
        
        if(self.userChoice == NOCHOICE)
        {
            // Do a random choice.
            self.userChoice = (PSRACTION) arc4random()%3;
            [self sendChoice:self.userChoice];
            [self submitChoice:self.userChoice];
            [self.gameTimer invalidate];
        }
        [self.gameTimer invalidate];
    }
}
-(void)disconnectMesh
{
    
    [self.appDelegate.mcManager disableMeshNetworking];
}
- (IBAction)disconnectPressed:(id)sender {
    [self disconnectMesh];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) sendChoice:(PSRACTION)choice{
    self.userChoice = choice;
    
    NSDictionary *message = @{@"choice": @(choice)};
    
    //  Convert text to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    
    //  Send data to connected peers
    NSError *error;
    [self.appDelegate.mcManager.session sendData:data toPeers:[self.appDelegate.mcManager.session connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    if(error)
    {
        NSLog(@"%@", error);
    }
}

#pragma mark - Play Again?
-(void) showPlayAgainView
{
    float xSize = self.view.frame.size.width;
    float ySize = self.view.frame.size.height;
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, ySize/2 - 20, xSize-40, 20)];
    UIButton *playAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    label.text = @"Would you like to play again?";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    playAgain.frame = CGRectMake(20+10+xSize/2, ySize/2 + 20, xSize/2-50, 30);
    [playAgain setTitle:@"Play Again!" forState:UIControlStateNormal];
    [playAgain addTarget:self action:@selector(playAgainPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:playAgain];
    
    dismissButton.frame = CGRectMake(20, ySize/2 + 20, xSize/2-50, 30);
    [dismissButton setTitle:@"Stop Playing :(" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dismissButton];
    
    view.backgroundColor = [UIColor whiteColor];
    view.alpha =0;
    [self.view addSubview:view];
    
    self.playAgainView = view;
    
    [UIView animateWithDuration:.3 animations:^{
        view.alpha =1;
    }];
}

-(void)dismissPressed
{
    [self disconnectMesh];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)playAgainPressed
{
    [UIView animateKeyframesWithDuration:.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.playAgainView.alpha=0;
    } completion:^(BOOL finished) {
        [self.playAgainView removeFromSuperview];
    }];
}

#pragma mark - Custom Setters
-(void)setGameTimer:(NSTimer *)gameTimer
{
    [_gameTimer invalidate];
    _gameTimer = gameTimer;
}

-(void)setPlayAgainView:(UIView *)playAgainView
{
    [_playAgainView removeFromSuperview];
    _playAgainView = playAgainView;
}

@end
