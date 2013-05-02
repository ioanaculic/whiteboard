//
//  Ellipse.m
//  desen
//
//  Created by Snow Leopard User on 25/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ellipse.h"

@implementation Ellipse

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
    CGContextAddEllipseInRect(context, rectangle);
    CGContextFillPath(context);
    }
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);  
    
}
-(NSString *)toSVG
{
    int cx=(int)((self.point0.x+self.point1.x)/2);
    int cy=(int)((self.point0.y+self.point1.y)/2);
    NSString *string=[NSString stringWithFormat:@"<ellipse cx=\"%d\" cy=\"%d\" rx=\"%d\" ry=\"%d\" stroke=\"%@\" stroke-width=\"%f\" %@ id=\"%d\"/>",
                      cx,
                      cy,
                      (int)ABS((self.point1.x-cx)),
                      (int)ABS((self.point1.y-cy)),
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
    Ellipse *ellipse=[[Ellipse alloc] initWithBackground:backgroundcolor color:color lineWidth:width];
    int cx=[[[element attributeForName:@"cx"] stringValue]intValue];
    int cy=[[[element attributeForName:@"cy"] stringValue]intValue];
    int rx=[[[element attributeForName:@"rx"] stringValue]intValue];
    int ry=[[[element attributeForName:@"ry"] stringValue]intValue];
    ellipse.point0=CGPointMake(cx-rx, cy-ry);
    ellipse.point1=CGPointMake(cx+rx, cy+ry);
    ellipse.identifier=[[[element attributeForName:@"id"] stringValue] intValue];
    return [ellipse autorelease];
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
    int cx=[[[element attributeForName:@"cx"] stringValue]intValue];
    int cy=[[[element attributeForName:@"cy"] stringValue]intValue];
    int rx=[[[element attributeForName:@"rx"] stringValue]intValue];
    int ry=[[[element attributeForName:@"ry"] stringValue]intValue];
    self.point0=CGPointMake(cx-rx, cy-ry);
    self.point1=CGPointMake(cx+rx, cy+ry);
    self.color=color;
    self.backgroundColor=backgroundcolor;
    self.width=width;
}
@end
