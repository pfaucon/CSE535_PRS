//
//  PSRUser.h
//  PaperScissorsRock
//
//  Created by Harsh Damania on 9/20/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "FCModel.h"

@interface PSRUser : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic) PSRUSER_GENDER gender;
@property (nonatomic) NSUInteger age;
@property (nonatomic) NSUInteger winCnt;
@property (nonatomic) NSUInteger lossCnt;
@property (nonatomic) NSDate *createdTime;
@property (nonatomic) NSDate *modifiedTime;

@end
