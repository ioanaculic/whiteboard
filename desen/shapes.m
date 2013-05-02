//
//  shapes.m
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "shapes.h"

static int ID=0;


@implementation shapes
@synthesize width;
@synthesize point0, point1;
@synthesize backgroundColor, color;
@synthesize identifier;
-(id)initWithBackground:(UIColor *)background color:(UIColor*) color lineWidth:(float)width
{
    self=[super init];
    if(self!=nil)
    {
        self.color=color;
        self.backgroundColor=background;
        self.width=width;
        ID=ID+1;
        self.identifier=ID;
    }
    return self;
}
-(void)dealloc
{
    [self.color release];
    [self.backgroundColor release];
    [super dealloc];
}
- (void) touchesBegan:(NSMutableArray*)_touches withset:(NSSet*)touchesset inview:(UIView*)view
{  
    
}
-(void)touchesMoved:(NSMutableArray *)_touches withset:(NSSet*)touchesset inview:(UIView*)view
{
    
}
- (void)touchesEnded:(NSMutableArray *)_touches withset:(NSSet *)touchesset inview:(UIView*)view
{
    
}
-(void) draw:(CGContextRef) context;
{
    
}
-(NSString *)toSVG
{
    return nil;
}
+(shapes *)toFigure:(NSXMLElement *) element
{
    return nil;
}
-(void) updateFigure:(NSXMLElement *) element
{
    
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
