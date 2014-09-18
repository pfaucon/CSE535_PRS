//
//  PSRViewController.m
//  PaperScissorsRock
//
//  Created by PFaucon on 9/17/14.
//  Copyright (c) 2014 Team Roflcopter. All rights reserved.
//

#import "PSRViewController.h"
#import "PSRAppDelegate.h"

@interface PSRViewController ()

@property (nonatomic, strong) PSRAppDelegate *appDelegate;

@end

@implementation PSRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _appDelegate = (PSRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}
- (IBAction)sendPressed:(id)sender {
    [self sendMyMessage];
}

-(void)sendMyMessage{
    NSString *stringToSend = @"Yo!";
    NSData *dataToSend = [stringToSend dataUsingEncoding:NSUTF8StringEncoding]; //[_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", stringToSend]]];
//    [_txtMessage setText:@""];
//    [_txtMessage resignFirstResponder];
}


-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}


@end
