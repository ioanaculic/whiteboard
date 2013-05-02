//
//  Line.m
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Line.h"

@implementation Line

-(id)initWithColor:(UIColor *)color lineWidth:(float)width
{
    self=[super initWithBackground:nil color:color lineWidth:width];
    return self;
}

- (void) touchesBegan:(NSMutableArray*)_touches withset:(NSSet*) touchesset inview:(UIView*)view
{
    if([_touches count]==1)
    {
        UITouch *touch=[_touches objectAtIndex:0];
        CGPoint point=[touch locationInView:view];
        self.point0=point;
        self.point1=point;
    }
    else
    {
        UITouch *touch=[_touches objectAtIndex:0];
        self.point0=[touch locationInView:view];
        touch=[_touches objectAtIndex:1];
        self.point1=[touch locationInView:view];
    }
}

-(void)touchesMoved:(NSMutableArray *)_touches withset:(NSSet*) touchesset inview:(UIView*)view
{
    if([_touches count]==1)
    {
        UITouch *touch=[_touches objectAtIndex:0];
        CGPoint point=[touch locationInView:view];
        self.point1=point;
    }
    else
    {
        UITouch *touch=[_touches objectAtIndex:0];
        self.point0=[touch locationInView:view];
        touch=[_touches objectAtIndex:1];
        self.point1=[touch locationInView:view]; 
    }
}

-(void)touchesEnded:(NSMutableArray *)_touches withset:(NSSet *)touchesset inview:(UIView*)view
{
    for(UITouch *touch in touchesset)
    {
        int i=[_touches indexOfObject:touch];
        //NSLog(@"%d", i);
        if(i!=0)
        {
            CGPoint aux=self.point0;
            self.point0=self.point1;
            self.point1=aux;
        }
    }
}
-(void) draw:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.width);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextMoveToPoint(context, self.point0.x, self.point0.y);
    CGContextAddLineToPoint(context,self.point1.x,self.point1.y);
    CGContextStrokePath(context);
}
-(NSString *)toSVG
{
    
   
    NSString *string=[NSString stringWithFormat:@"<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke=\"%@\" stroke-width=\"%f\" id=\"%d\"/>",(int)self.point0.x,(int)self.point0.y,(int)self.point1.x,(int) self.point1.y,[self.color toHexa] ,self.width, self.identifier];
    return string;
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
    Line *line=[[Line alloc] initWithColor:color lineWidth:width];
    
    line.point0=CGPointMake([[[element attributeForName:@"x1"] stringValue]intValue],[[[element attributeForName:@"y1"] stringValue]intValue]);
    line.point1=CGPointMake([[[element attributeForName:@"x2"] stringValue]intValue],[[[element attributeForName:@"y2"] stringValue]intValue]);
    line.identifier=[[[element attributeForName:@"id"] stringValue] intValue];
        return [line autorelease];
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
    self.point0=CGPointMake([[[element attributeForName:@"x1"] stringValue]intValue],[[[element attributeForName:@"y1"] stringValue]intValue]);
    self.point1=CGPointMake([[[element attributeForName:@"x2"] stringValue]intValue],[[[element attributeForName:@"y2"] stringValue]intValue]); 
    self.color=color;
    self.width=width;
}


@end
