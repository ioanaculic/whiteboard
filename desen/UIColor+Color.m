//
//  UIColor+Color.m
//  desen
//
//  Created by Snow Leopard User on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Color.h"

@implementation UIColor (Color)
-(NSString *)toHexa
{
    int red;
    int green;
    int blue;
    //CGFloat alpha;
    CGColorRef color = [self CGColor];
    int numComponents = CGColorGetNumberOfComponents(color);    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        red = (int)components[0]*255;
        green =(int)components[1]*255;
        blue =(int)components[2]*255;
        //alpha = components[3];
    }
    NSString *s=[NSString stringWithFormat:@"#%02x%02x%02x",red,green,blue];
    return s;
}
+(int)toDec:(char) c
{
    if (c>='0' && c<='9') return c-'0';
    else if (c>='a' && c<='f') return c-'a'+10;
    else if (c>='A' && c<='F') return c-'A'+10;
    return 0;
}
+(UIColor *) toColor:(NSString *) string
{
    float red;
    float green;
    float blue;
    if ([string length] !=7 )return nil;
        else
        {
            if([string characterAtIndex:0]!='#') return nil;
               else
               {
                   red=([self toDec:[string characterAtIndex:1]]*16+[self toDec:[string characterAtIndex:2]])/255.0;
                   green=([self toDec:[string characterAtIndex:3]]*16+[self toDec:[string characterAtIndex:4]])/255.0;
                   blue=([self toDec:[string characterAtIndex:5]]*16+[self toDec:[string characterAtIndex:6]])/255.0;
               }
        }
    UIColor *color=[UIColor colorWithRed:red
                                  green:green
                                   blue:blue
                                  alpha:1.0];
    return color;
}
@end
