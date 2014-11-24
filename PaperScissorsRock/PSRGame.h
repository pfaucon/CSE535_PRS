//
//  PSRGame.h
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSRUser.h"

#define PSRActionString(enum) [@[@"ROCK",@"PAPER",@"SCISSORS"] objectAtIndex:enum]

typedef NS_ENUM(int, WINCONDITION) {
    DRAW=0,
    WIN =1,
    LOSS=2
};

@interface PSRGame : NSObject

@property int score;
@property PSRACTION opponentsLastChoice;
@property (nonatomic, strong) PSRUser *gameUser;

-(WINCONDITION)playerWonBySubmitting:(PSRACTION) choice;
-(WINCONDITION)bluetoothPlayPlayerOneChoice:(PSRACTION) playerOneChoice playerTwoChoice:(PSRACTION) playerTwoChoice;

@end
