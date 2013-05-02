//
//  Rectangle.m
//  desen
//
//  Created by Snow Leopard User on 25/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

-(void) draw:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.width);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetFillColorWithColor(context,self.backgroundColor.CGColor);
    int x,y;
    x=MIN(self.point0.x, self.point1.x);
    y=MIN(self.point0.y, self.point1.y);
    int height,width;
    width=ABS(self.point0.x-self.point1.x);
    height=ABS(self.point0.y-self.point1.y);    
    CGRect rectangle = CGRectMake(x,y,width,height); 
    if(self.backgroundColor!=nil)
    {
        CGContextAddRect(context, rectangle);
        CGContextFillPath(context);
    }
    CGContextAddRect(context, rectangle);    
    CGContextStrokePath(context);
    
}
-(NSString *)toSVG
{
        NSString *string=[NSString stringWithFormat:@"<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"%d\" stroke=\"%@\" stroke-width=\"%f\" %@ id=\"%d\"/>",
                          (int)MIN(self.point0.x, self.point1.x),
                          (int)MIN(self.point0.y, self.point1.y),
                          (int)(ABS(self.point1.x-self.point0.x)),
                          (int)(ABS(self.point1.y-self.point0.y)),
                          [self.color toHexa],
                          self.width,
                          ([self.backgroundColor toHexa]==nil?@"":[NSString stringWithFormat:@"fill=\"%@\"", [self.backgroundColor toHexa]]),
                          self.identifier];
        return string;
}
+(shapes *)toFigure:(NSXMLElement *) element
{
    UIColor *color;
    NSString *scolor=[[element attributeForName:@"stroke"] stringValue];
    if(scolor!=nil)
        color=[UIColor toColor:scolor];
    else color=[UIColor blackColor];
    UIColor *backgroundcolor;
    NSString *sbackgroundcolor=[[element attributeForName:@"fill"] stringValue];
    if(sbackgroundcolor!=nil)
        backgroundcolor=[UIColor toColor:sbackgroundcolor];
    else backgroundcolor=nil;
    float width;
    NSString *swidth=[[element attributeForName:@"stroke-width"] stringValue];
    if(swidth!=nil)
        width=[swidth floatValue];
    else width=2.0;
    Rectangle *rectangle=[[Rectangle alloc] initWithBackground:backgroundcolor color:color lineWidth:width];
    int x=[[[element attributeForName:@"x"] stringValue]intValue];
    int y=[[[element attributeForName:@"y"] stringValue]intValue];
    int rectWidth=[[[element attributeForName:@"width"] stringValue]intValue];
    int rectHeight=[[[element attributeForName:@"height"] stringValue]intValue];
    rectangle.point0=CGPointMake(x, y);
    rectangle.point1=CGPointMake(x+rectWidth, y+rectHeight);
    rectangle.identifier=[[[element attributeForName:@"id"] stringValue] intValue];
    return [rectangle autorelease];
}
-(void) updateFigure:(DDXMLElement *)element
{
    UIColor *color;
    NSString *scolor=[[element attributeForName:@"stroke"] stringValue];
    if(scolor!=nil)
        color=[UIColor toColor:scolor];
    else color=[UIColor blackColor];
    UIColor *backgroundcolor;
    NSString *sbackgroundcolor=[[element attributeForName:@"fill"] stringValue];
    if(sbackgroundcolor!=nil)
        backgroundcolor=[UIColor toColor:sbackgroundcolor];
    else backgroundcolor=nil;
    float width;
    NSString *swidth=[[element attributeForName:@"stroke-width"] stringValue];
    if(swidth!=nil)
        width=[swidth floatValue];
    else width=2.0;
    int x=[[[element attributeForName:@"x"] stringValue]intValue];
    int y=[[[element attributeForName:@"y"] stringValue]intValue];
    int rectWidth=[[[element attributeForName:@"width"] stringValue]intValue];
    int rectHeight=[[[element attributeForName:@"height"] stringValue]intValue];
    self.point0=CGPointMake(x, y);
    self.point1=CGPointMake(x+rectWidth, y+rectHeight);
    self.backgroundColor=backgroundcolor;
    self.color=color;
    self.width=width;
}
@end
