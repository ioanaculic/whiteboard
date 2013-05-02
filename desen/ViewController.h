//
//  ViewController.h
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desen.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "ShapesMessageProtocol.h"
#import "ContactsView.h"

@interface ViewController : UIViewController<ShapesMessageProtocol>
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIButton *connectionButton;
@property (retain, nonatomic) NSMutableArray *contacts;
-(IBAction)butonline;
-(IBAction)butonrectangle;
-(IBAction)butonEllipse;
-(IBAction)colorRed;
-(IBAction)colorBlue;
-(IBAction)butonFree;
-(IBAction)butonClear;
-(IBAction)colorYellow;
-(IBAction)backgroundRed;
-(IBAction)backgroundBlue;
-(IBAction)backgroundNull;
-(IBAction)slider:(UISlider*)sender;
-(IBAction)showContacts:(id) sender;
//-(IBAction)SVG;
-(IBAction)pdf;
-(IBAction)test;
-(IBAction)connect;

- (BOOL)connectToStream;
@property(nonatomic,strong) XMPPStream *xmppStream;
@property(nonatomic,retain) IBOutlet desen *suprafataDesen;
@property (retain, nonatomic) IBOutlet UIImageView *color;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundColor;
@end
