//
//  PSRAppDelegate.h
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface PSRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCManager *mcManager;

@end
