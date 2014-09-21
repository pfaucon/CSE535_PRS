//
//  PSRGameViewController.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRGameViewController.h"
#import "PSRGame.h"

@interface PSRGameViewController ()
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
    self.congratulationsLabel.hidden = ![self.game playerWonBySubmitting:choice];
    
    self.opponentsChoiceLabel.text = [NSString stringWithFormat:@"The Computer Picked: %@", PSRActionString(self.game.opponentsLastChoice)];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    
    [self updateRecordLabel];
}

@end
