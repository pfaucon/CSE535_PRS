//
//  MGGlyphDetectorView.h
//  Test_multiGesture
//
//  Created by Nicolas Salhuana on 9/23/14.
//  Copyright (c) 2014 Nicolas Salhuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMGlyphDetector.h"

@class MGlyphDetectorView;

@protocol MGlyphDetectorViewDelegate <NSObject>
@optional
-(void)wtmGlyphDetectorView:(MGlyphDetectorView*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score;
@end

@interface MGlyphDetectorView : UIView
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) BOOL enableDrawing;

-(void)loadTemplatesWithNames:(NSString*)firstTemplate, ... NS_REQUIRES_NIL_TERMINATION;

-(NSString *)getGlyphNamesString;
@end
