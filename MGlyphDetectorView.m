//
//  MGGlyphDetectorView.m
//  Test_multiGesture
//
//  Created by Nicolas Salhuana on 9/23/14.
//  Copyright (c) 2014 Nicolas Salhuana. All rights reserved.
//

#import "MGlyphDetectorView.h"

@interface MGlyphDetectorView() <WTMGlyphDelegate>
@property (nonatomic, strong) WTMGlyphDetector *glyphDetector;
@property (nonatomic, strong) NSMutableArray *glyphNamesArray;
@property (nonatomic, strong) UIBezierPath *myPath;
@end

@implementation MGlyphDetectorView
@synthesize delegate;
@synthesize myPath;
@synthesize enableDrawing;
@synthesize glyphDetector;
@synthesize glyphNamesArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGestureDetector];
        
        self.backgroundColor = [UIColor clearColor];
        self.enableDrawing = YES;
        
        self.myPath = [[UIBezierPath alloc] init];
        self.myPath.lineCapStyle = kCGLineCapRound;
        self.myPath.miterLimit = 0;
        self.myPath.lineWidth = 10;
    }
    return self;
}

-(void)initGestureDetector
{
    self.glyphDetector = [WTMGlyphDetector detector];
    self.glyphDetector.delegate = self;
    self.glyphDetector.timeoutSeconds = 1;
    
    if(self.glyphNamesArray == nil)
        self.glyphNamesArray = [[NSMutableArray alloc] init];
}

#pragma mark - Public interfaces

-(NSString *)getGlyphNamesString
{
    if (self.glyphNamesArray == nil || [self.glyphNamesArray count] <= 0)
        return @"";
    return [self.glyphNamesArray componentsJoinedByString:@", "];
}

-(void)loadTemplatesWithNames:(NSString *)firstTemplate, ...
{
    va_list args;
    va_start(args, firstTemplate);
    for (NSString *glyphName = firstTemplate; glyphName != nil; glyphName = va_arg(args, id)) {
        if(![glyphName isKindOfClass:[NSString class]])
            continue;
        [self.glyphNamesArray addObject:glyphName];
        
        NSData *jsonData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:glyphName ofType:@"json"]];
        [self.glyphDetector addGlyphFromJSON:jsonData name:glyphName];
    }
    va_end(args);
}

#pragma mark - WTMGlyphDelegate

-(void)glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    if([self.delegate respondsToSelector:@selector(wtmGlyphDetectorView:glyphDetected:withScore:)])
        [self.delegate wtmGlyphDetectorView:self glyphDetected:glyph withScore:score];
        
    [self performSelector:@selector(clearDrawingIfTimeout) withObject:nil afterDelay:1.0f];
}

-(void)glyphResults:(NSArray *)results
{
    //Raw results from library?
}

#pragma mark - Touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL hasTimeOut = [self.glyphDetector hasTimedOut];
    if(hasTimeOut)
    {
        NSLog(@"Gesture detector reset");
        [self.glyphDetector reset];
        
        if(self.enableDrawing) {
            [self.myPath removeAllPoints];
            [self setNeedsDisplay];
        }
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.glyphDetector addPoint:point];
    
    [super touchesBegan:touches withEvent:event];
    
    if(!self.enableDrawing)
        return;
    [self.myPath moveToPoint:point];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.glyphDetector addPoint:point];
    [super touchesMoved:touches withEvent:event];
    
    if(!self.enableDrawing)
        return;
    
    [self.myPath addLineToPoint:point];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.glyphDetector addPoint:point];
    [self.glyphDetector detectGlyph];
    
    [super touchesEnded:touches withEvent:event];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(!self.enableDrawing)
        return;
    
    [[UIColor blueColor] setStroke];
    [self.myPath strokeWithBlendMode:kCGBlendModeNormal alpha:0.5];
}

-(void)clearDrawingIfTimeout
{
    if(!self.enableDrawing)
        return;
    
    BOOL hasTimeOut = [self.glyphDetector hasTimedOut];
    if(!hasTimeOut)
        return;
    [self.myPath removeAllPoints];
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
