//
//  FreeHand.m
//  desen
//
//  Created by Snow Leopard User on 03/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreeHand.h"

@implementation FreeHand
@synthesize paths;
-(id)initWithColor:(UIColor *) color lineWidth:(float) width
{
    
    self=[super initWithBackground:nil color:color lineWidth: width];  
    if(self!=nil)
    {
    self.paths=[[NSMutableDictionary alloc] init];
        //NSLog(@"dictionary created");
    [paths release];
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
    [self.paths release];
    //NSLog(@"dictionary released");
}

-(void) draw:(CGContextRef)context
{
    for (id key in self.paths) 
    {
        
        NSMutableArray *points = [self.paths objectForKey:key];
        self.point0=[[points objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(context,self.point0.x,self.point0.y);
        CGContextSetLineWidth(context, self.width);        
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        if([points count]==1)
        {
            CGContextAddLineToPoint(context, self.point0.x+1, self.point0.y+1); 
        }
        else
        {
        for(int i=0; i<[points count]; i=i+2)
        {                
              
            self.point1 = [[points objectAtIndex:i] CGPointValue];
            //CGContextAddLineToPoint(context, self.point1.x, self.point1.y);  
            if(i<1)
            {
              CGContextAddLineToPoint(context, self.point1.x, self.point1.y);   
            }
            else
            {
                //CGPoint cpoint1=[[points objectAtIndex:i-2]CGPointValue];
                CGPoint cpoint2=[[points objectAtIndex:i-1]CGPointValue];
                CGContextAddQuadCurveToPoint(context, cpoint2.x, cpoint2.y, self.point1.x, self.point1.y);            }
            
        }
        }
        CGContextStrokePath(context);	
    }

}
- (void) touchesBegan:(NSMutableArray*)_touches withset:(NSSet*) touchesset inview:(UIView*)view
        {  
                for(UITouch *touch in touchesset)
                {
                    NSMutableArray *points=[[NSMutableArray alloc] init];
                    //NSLog(@"touch %d from aray:%@",j,touch);
                    [self.paths setObject:points forKey:[NSString stringWithFormat:@"%p",touch]];
                    //NSLog(@"object set in dictionary");
                   // NSLog(@"count dictionary %d",[self.paths count]);
                    //NSLog(@"pointer touch %p",touch);
                    [points addObject:[NSValue valueWithCGPoint:[touch locationInView:view]]]; 
                    //NSLog(@"point added");
                    [points release];
                    //NSLog(@"points released");
                }
        }
-(void)touchesMoved:(NSMutableArray *)_touches withset:(NSSet*) touchesset inview:(UIView*)view
        {
            //NSLog(@"touchesmoved");
            
            for(int i=0; i<[_touches count]; i=i+1)
            {
                //NSLog(@"entered for");
                UITouch *touch=[_touches objectAtIndex:i];
                NSMutableArray *points=[self.paths objectForKey:[NSString stringWithFormat:@"%p",touch]];
                [points addObject:[NSValue valueWithCGPoint:[touch locationInView:view]]]; 
                
            }
        }
-(NSArray*)toSVGs
{
    NSString *secondString;
    NSMutableArray * strings = [NSMutableArray array];
    int i;
    for (id key in self.paths) 
    {    
        NSMutableString *firstString = [NSMutableString stringWithString: @"<polyline points=\""];
        NSMutableArray *points = [self.paths objectForKey:key];
        for(i=0; i<[points count]-1; i=i+1)
        {
            secondString =[NSString stringWithFormat:@"%d, %d, ",(int)[[points objectAtIndex:i]CGPointValue].x,(int)[[points objectAtIndex:i]CGPointValue].y];
            [firstString appendString:secondString];
        }
        secondString =[NSString stringWithFormat:@"%d, %d\"",(int)[[points objectAtIndex:i]CGPointValue].x,(int)[[points objectAtIndex:i]CGPointValue].y];
        [firstString appendString:secondString];
        secondString=[NSString stringWithFormat:@" stroke=\"%@\" stroke-width=\"%f\" id=\"%@\"/>",[self.color toHexa],self.width, [NSString stringWithFormat:@"%d%@",self.identifier, key]];
        [firstString appendString:secondString];
        [strings addObject:firstString];
    }
    return strings;
}
-(NSString *)toSVG
{
    NSArray *strings=[self toSVGs];
    NSMutableString *firstString =[NSMutableString stringWithString: [strings objectAtIndex:0]]; 
    NSString *secondString;  
    for(int i=1; i<[strings count]; i=i+1)
    {
        secondString=[strings objectAtIndex:i];
        [firstString appendString:secondString];
    }
    return firstString;
}

+(shapes *)toFigure:(NSXMLElement *) element
{
    UIColor *color;
    NSString *scolor=[[element attributeForName:@"stroke"] stringValue];
    if(scolor!=nil)
        color=[UIColor toColor:scolor];
    else color=[UIColor blackColor];
    float width;
    NSString *swidth=[[element attributeForName:@"stroke-width"] stringValue];
    if(swidth!=nil)
        width=[swidth floatValue];
    else width=2.0;
    FreeHand *free=[[FreeHand alloc] initWithColor:color lineWidth:width];
    NSString *spoints=[[element attributeForName:@"points"] stringValue];
    NSArray *points=[spoints componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    free.paths=[NSMutableDictionary dictionary];
    NSMutableArray *figurePoints=[NSMutableArray array];
    for(int i=0; i<[points count]; i=i+2)
    {
        if(i+1<[points count])
            [figurePoints addObject:[NSValue valueWithCGPoint:CGPointMake([[points objectAtIndex:i] intValue], [[points objectAtIndex:i+1] intValue] )]];
    }
    [free.paths setObject:figurePoints forKey:@"a"];
    free.identifier=[[[element attributeForName:@"id"] stringValue] intValue];
    return [free autorelease];
}
-(void) updateFigure:(DDXMLElement *)element
{
    UIColor *color;
    NSString *scolor=[[element attributeForName:@"stroke"] stringValue];
    if(scolor!=nil)
        color=[UIColor toColor:scolor];
    else color=[UIColor blackColor];
    float width;
    NSString *swidth=[[element attributeForName:@"stroke-width"] stringValue];
    if(swidth!=nil)
        width=[swidth floatValue];
    else width=2.0;
    self.color=color;
    self.width=width;
    NSString *spoints=[[element attributeForName:@"points"] stringValue];
    NSArray *points=[spoints componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    self.paths=[NSMutableDictionary dictionary];
    NSMutableArray *figurePoints=[NSMutableArray array];
    for(int i=0; i<[points count]; i=i+2)
    {
        if(i+1<[points count])
            [figurePoints addObject:[NSValue valueWithCGPoint:CGPointMake([[points objectAtIndex:i] intValue], [[points objectAtIndex:i+1] intValue] )]];
    }
    [self.paths setObject:figurePoints forKey:@"a"];
}
@end
