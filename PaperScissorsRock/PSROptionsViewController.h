//
//  PSROptionsViewController.h
//  PaperScissorsRock
//
//  Created by John Yu on 11/22/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;

#import "PSRGameViewController.h"
#import "PSRBLGameViewController.h"
#import "PSRAppDelegate.h"

@interface PSROptionsViewController : UIViewController<MCBrowserViewControllerDelegate>

@property (nonatomic, strong) PSRAppDelegate *appDelegate;

@property (nonatomic, strong) PSRUser *gameUser;
- (IBAction)connectToOtherPlayer:(id)sender;

@end
