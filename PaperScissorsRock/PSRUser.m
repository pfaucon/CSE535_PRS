//
//  PSRUser.m
//  PaperScissorsRock
//
//  Created by Harsh Damania on 9/20/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRUser.h"

@implementation PSRUser

- (BOOL)shouldInsert
{
    self.createdTime = [NSDate date];
    self.modifiedTime = self.createdTime;
    return YES;
}

- (BOOL)shouldUpdate
{
    self.modifiedTime = [NSDate date];
    return YES;
}

@end
