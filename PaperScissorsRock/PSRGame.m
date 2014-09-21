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
    BOOL playerDidWin = NO;
    
    if(((choice-computerChoice)+3)%3 ==1)
    {
        self.score++;
        playerDidWin = YES;
    }
    
    [self updatePlayerRecord:playerDidWin];
    
    return playerDidWin;
}

- (void)updatePlayerRecord:(BOOL)playerDidWin
{
    if (playerDidWin) {
        [PSRUser executeUpdateQuery:@"UPDATE $T SET winCnt = winCnt + 1 WHERE id = ?",self.gameUser.primaryKey];
    } else {
        [PSRUser executeUpdateQuery:@"UPDATE $T SET lossCnt = lossCnt + 1 WHERE id = ?",self.gameUser.primaryKey];
    }
}


@end
