//
//  PSRGame.h
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PSRActionString(enum) [@[@"ROCK",@"PAPER",@"SCISSORS"] objectAtIndex:enum]
#define userTypeString(enum) [@[@"expert",@"parent",@"child",@"unknown"] objectAtIndex:enum];

@interface PSRGame : NSObject

@property int score;
@property PSRACTION opponentsLastChoice;

-(BOOL)playerWonBySubmitting:(PSRACTION) choice;

@end
