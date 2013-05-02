//
//  desen.h
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shapes.h"
#import "Line.h"
#import "Rectangle.h"
#import "Ellipse.h"
#import "FreeHand.h"
#import "ShapesMessageProtocol.h"
#import <MessageUI/MFMailComposeViewController.h>
#define LINE 1
#define RECTANGLE 2
#define FREE 4
#define ELLIPSE 3
#define RED 10;
@interface desen : UIView<MFMailComposeViewControllerDelegate>
@property(nonatomic)IBOutlet id<ShapesMessageProtocol> protocol;
@property(nonatomic,retain) UIImage *bitmap;
@property(nonatomic) Boolean connected;
@property(nonatomic, retain) NSMutableDictionary *figuriDict;
//@property(nonatomic, retain) NSMutableArray *pagini;
@property(nonatomic, retain) NSMutableArray *figuri;
@property(nonatomic, retain) NSMutableArray *touches;
@property(nonatomic, retain) NSMutableDictionary *paths; 
@property(nonatomic) int butonFigura;
@property(nonatomic,retain) UIColor *foreground;
@property(nonatomic,retain) UIColor *background;
@property(nonatomic) float lineWidth;
@property(nonatomic,retain) NSString *keyFiguri;
-(void) setup;
-(void) awakeFromNib;
-(void) clear;
-(void)writeSVG;
-(void)readSVGFromXmlElement:(NSXMLElement *)l;
-(void)readSVG:(NSString *)string;
-(void) updateBitmap;
-(void) createPDF;
@end
