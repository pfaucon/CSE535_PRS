//
//  PSRGameViewController.h
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSRUser.h"

@interface PSRGameViewController : UIViewController

@property NSString *username;
@property (nonatomic, strong) PSRUser *gameUser;

@end
