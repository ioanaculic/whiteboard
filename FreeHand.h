//
//  FreeHand.h
//  desen
//
//  Created by Snow Leopard User on 03/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shapes.h"

@interface FreeHand : shapes
@property(nonatomic, retain) NSMutableDictionary *paths;
-(id)initWithColor:(UIColor *) color lineWidth:(float) width;

@end
