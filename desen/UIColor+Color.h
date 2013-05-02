//
//  UIColor+Color.h
//  desen
//
//  Created by Snow Leopard User on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)
-(NSString *)toHexa;
+(int)toDec:(char) c;
+(UIColor *) toColor:(NSString *) string;
@end
