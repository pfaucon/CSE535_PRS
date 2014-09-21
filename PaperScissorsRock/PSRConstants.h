//
//  PSRConstants.h
//  PaperScissorsRock
//
//  Created by Harsh Damania on 9/20/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSRConstants : NSObject

typedef NS_ENUM(NSUInteger, PSRACTION) {
    ROCK,
    PAPER,
    SCISSORS,
};

typedef NS_ENUM(NSUInteger, PSRUSER_GENDER) {
    MALE,
    FEMALE
};

@end
