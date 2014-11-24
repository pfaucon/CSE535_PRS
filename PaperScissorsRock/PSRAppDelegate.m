//
//  PSRAppDelegate.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRAppDelegate.h"
#import "FCModel.h"

@implementation PSRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //configure ubertesters -- API key is in the plist
    //    [[Ubertesters shared] initialize];
    //    [[Ubertesters shared] UTLog:@"Launch Success!" withLevel:UTLogLevelInfo];
    
    //initialization code
    _mcManager = [[MCManager alloc] init];
    
    [self loadDatabase];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadDatabase
{
    //    [FCModel closeDatabase];
    
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"psr.sqlite3"];
    NSLog(@"DB path: %@", dbPath);
    //    [NSFileManager.defaultManager removeItemAtPath:dbPath error:NULL];
    
    [FCModel openDatabaseAtPath:dbPath withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        [db setCrashOnErrors:YES];
        db.traceExecution = YES;
        [db beginTransaction];
        
        void (^failedAt)(int statement) = ^(int statement){
            int lastErrorCode = db.lastErrorCode;
            NSString *lastErrorMessage = db.lastErrorMessage;
            [db rollback];
            NSAssert3(0, @"Migration statement %d failed, code %d: %@", statement, lastErrorCode, lastErrorMessage);
        };
        
        if (*schemaVersion < 1) {
            if (! [db executeUpdate:
                   @"CREATE TABLE PSRUser ("
                   @"   id              INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"   username        TEXT NOT NULL,"
                   @"   gender          INTEGER NOT NULL,"
                   @"   age             INTEGER NOT NULL,"
                   @"   winCnt          INTEGER NOT NULL DEFAULT 0,"
                   @"   lossCnt         INTEGER NOT NULL DEFAULT 0,"
                   @"   createdTime     INTEGER NOT NULL,"
                   @"   modifiedTime    INTEGER NOT NULL"
                   @");"
                   ]) failedAt(1);
            if (! [db executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS name ON PSRUser (username);"]) failedAt(2);
            
            *schemaVersion = 1;
        }
        
        [db commit];
    }];
}

@end
