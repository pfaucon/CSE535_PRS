//
//  PSRGame.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRGame.h"

@implementation PSRGame

-(WINCONDITION)playerWonBySubmitting:(PSRACTION) choice
{
    PSRACTION computerChoice = (PSRACTION) arc4random()%3;
    self.opponentsLastChoice = computerChoice;
    WINCONDITION outcome = (WINCONDITION) ((choice-computerChoice)+3)%3;
    
    if( outcome == WIN)
    {
        [self incrementWins];
    }
    if(outcome == LOSS)
    {
        [self incrementLosses];
    }
    
    return outcome;
}

-(WINCONDITION)bluetoothPlayPlayerOneChoice:(PSRACTION) playerOneChoice playerTwoChoice:(PSRACTION) playerTwoChoice
{
    self.opponentsLastChoice = playerTwoChoice;
    WINCONDITION outcome = (WINCONDITION) ((playerOneChoice - playerTwoChoice)+3)%3;
    
    if( outcome == WIN)
    {
        [self incrementWins];
    }
    if(outcome == LOSS)
    {
        [self incrementLosses];
    }
    
    return outcome;
}

-(void)incrementWins
{
    self.gameUser.winCnt = self.gameUser.winCnt+1;
    [self.gameUser save];
    self.score = (int)self.gameUser.winCnt;
}
-(void)incrementLosses
{
    self.gameUser.lossCnt = self.gameUser.lossCnt+1;
    [self.gameUser save];
    self.score = (int)self.gameUser.winCnt;
}

- (void)updatePlayerRecord:(BOOL)playerDidWin
{
}

#pragma mark - Custom Setters
-(void)setGameUser:(PSRUser *)gameUser
{
    _gameUser = gameUser;
    self.score = (int)_gameUser.winCnt;
}

@end
