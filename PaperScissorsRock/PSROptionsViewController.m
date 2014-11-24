//
//  PSROptionsViewController.m
//  PaperScissorsRock
//
//  Created by John Yu on 11/22/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSROptionsViewController.h"

@interface PSROptionsViewController ()

@end

@implementation PSROptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.appDelegate.mcManager disableMeshNetworking];
    
    self.appDelegate = (PSRAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.mcManager setupPeerAndSessionWithDisplayName:self.gameUser.username];
    [self.appDelegate.mcManager advertiseSelf:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStateNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueToComputerGame"])
    {
        PSRGameViewController *dest = segue.destinationViewController;
        dest.gameUser = self.gameUser;
    }
}


-(void)didChangeStateNotification:(NSNotification *)notification{
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if(state == MCSessionStateConnected)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            PSRBLGameViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothGameView"];
            
            nextVC.gameUser = self.gameUser;
            
            [self.navigationController pushViewController:nextVC animated:YES];
        });
    }
}

- (void) dismissBrowserVC{
    [self.appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

- (IBAction)connectToOtherPlayer:(id)sender
{
    if([self.appDelegate.mcManager.session.connectedPeers count] == 0)
    {
        [self.appDelegate.mcManager setupMCBrowser];
        [self.appDelegate.mcManager.browser setDelegate:self];
        [self presentViewController:self.appDelegate.mcManager.browser animated:YES completion:Nil];
    }
    
    else
    {
        PSRBLGameViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothGameView"];
        
        nextVC.gameUser = self.gameUser;
        
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}
@end
