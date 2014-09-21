//
//  PSRLandingViewController.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRLandingViewController.h"
#import "PSRUser.h"

@interface PSRLandingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *signupUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *gameOnButton;

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic, weak) PSRUser *gameUser;

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
    self.signUpButton.enabled = NO;
}

- (IBAction)gameOn:(id)sender {
    self.gameUser = [PSRUser firstInstanceWhere:@"username = ? ORDER BY id LIMIT 1", self.loginUsernameField.text];
    
    if (self.gameUser) {
        [self performSegueWithIdentifier:@"segueToGame" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"User not found" message:[NSString stringWithFormat:@"User %@ not found", self.loginUsernameField.text]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)signUpPressed:(id)sender {
    PSRUser *newUser = [PSRUser new];
    newUser.username = self.signupUsernameTextField.text;
    newUser.age = [self.ageTextField.text integerValue];
    newUser.gender  = self.genderSegmentedControl.selectedSegmentIndex;
    
    FCModelSaveResult result = [newUser save];
    if (result) {
        self.gameUser = newUser;
        
        [self performSegueWithIdentifier:@"segueToGame" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)fieldUpdatedContents:(id)sender
{
    if(self.signupUsernameTextField.text.length >0 && self.ageTextField.text.length>0)
    {
        self.signUpButton.enabled = YES;
    }
    else
    {
        self.signUpButton.enabled = NO;
    }
    
    if (self.loginUsernameField.text.length > 0) {
        self.gameOnButton.enabled = YES;
    } else {
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
    dest.gameUser = self.gameUser;
}


@end
