//
//  PSRLandingViewController.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRLandingViewController.h"

@interface PSRLandingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *gameOnButton;

@end

@implementation PSRLandingViewController

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
    
    self.gameOnButton.enabled = NO;
}

- (IBAction)gameOn:(id)sender {
    [self performSegueWithIdentifier:@"segueToGame" sender:self];
}
- (IBAction)fieldUpdatedContents:(id)sender {
    
    if(self.usernameTextField.text.length >0 && self.ageTextField.text.length>0)
    {
        self.gameOnButton.enabled = YES;
    }
    else
    {
        self.gameOnButton.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self fieldUpdatedContents:textField];
    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PSRGameViewController *dest = segue.destinationViewController;
    dest.username = self.usernameTextField.text;
}


@end
