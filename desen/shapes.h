//
//  shapes.h
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Color.h"
#import "DDXML.h"

@interface shapes : NSObject
@property(nonatomic) CGPoint point0, point1;
@property(nonatomic) int identifier;
@property(nonatomic,retain) UIColor *backgroundColor, *color;
@property(nonatomic) float width;
-(id)initWithBackground:(UIColor *)background color:(UIColor*) color lineWidth:(float)width;
-(void) draw: (CGContextRef) context;
-(void)touchesBegan:(NSMutableArray*)_touches withset:(NSSet*)touchesset inview:(UIView*)view;
-(void)touchesMoved:(NSMutableArray *)_touches withset:(NSSet*)touchesset inview:(UIView*)view;
-(void)touchesEnded:(NSMutableArray *)_touches withset:(NSSet*) touchesset inview:(UIView*)view;
-(NSString *)toSVG;
+(shapes *)toFigure:(NSXMLElement *) element;
-(void) updateFigure:(NSXMLElement *) element;
-(void)setup;

@end
