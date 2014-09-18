//
//  PSRGame.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRGame.h"

@implementation PSRGame


-(BOOL)playerWonBySubmitting:(PSRACTION) choice
{
    PSRACTION computerChoice = (PSRACTION) arc4random()%3;
    self.opponentsLastChoice = computerChoice;
    
    if(((choice-computerChoice)+3)%3 ==1)
    {
        self.score++;
        return YES;
    }
    
    return NO;
}


@end
