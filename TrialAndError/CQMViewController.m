//
//  CQMViewController.m
//  TrialAndError
//
//  Created by sanooj_s on 5/16/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import "CQMViewController.h"

@interface TriangleView : UIView

@end


@implementation TriangleView

-(void)drawRect:(CGRect)rect
{
//    UIBezierPath* bezierPath = nil;
//    bezierPath = [UIBezierPath bezierPath];
//    
//    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
//    [bezierPath addLineToPoint:CGPointMake(55.0, 55.0)]; //(0,100)
//    [bezierPath addLineToPoint:CGPointMake(100.0, 100.0)];
//    
//    [bezierPath closePath];
//    
//    [[UIColor redColor] set];
//    
//    [bezierPath fill];
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    
    /*
     
     minX,maxY ------------ maxX,maxY
     |                              |
     |                              |
     |          midX.midY           |
     |                              |
     |                              |
     minX,minY ------------ maxX,minY
     
     */
    
//    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
//    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // mid right
//    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
//    

    
    /**
     *  Draws normal rect 
     *  
      *
         /\
        /  \
       /    \
      /______\
     
     */
 
//    CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
//    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
//    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    
    CGContextMoveToPoint(ctx, CGRectGetMinY(rect), CGRectGetMidX(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 253/255, 109/255, 9/255, 1);
    CGContextFillPath(ctx);
    
    

}

@end


@interface CQMViewController ()

@end

@implementation CQMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self buttonDraw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDraw
{
    if (![self button])
    {
        UIButton* tmpButton = nil;
        tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 20.0, 40.0, 40.0)];
        [tmpButton setBackgroundColor:[UIColor orangeColor]];
        
        TriangleView* tVW;
        tVW = [[TriangleView alloc] initWithFrame:CGRectMake(80.0, 40.0, 60.0, 60.0)];
        [tVW setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:(UIView *)tVW];
        
        
        [self setButton:tmpButton];
        [[self view] addSubview:(UIView *)[self button]];
        
    }
}

-(void)dealloc
{
    [self setButton:nil];
}

@end
