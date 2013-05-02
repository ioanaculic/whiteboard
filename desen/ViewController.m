//
//  ViewController.m
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize suprafataDesen;
@synthesize label;
@synthesize xmppStream;
@synthesize connectionButton;
@synthesize color;
@synthesize backgroundColor;
@synthesize contacts;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil)
    {
        self.contacts=[[NSMutableArray alloc] init];
        [self.contacts addObject:@"svg.xmpp@gmail.com"];
        [self.contacts addObject:@"lezeca1@gmail.com"];
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) dealloc
{
    [super dealloc];
    [self.suprafataDesen release];
    [self.label release];
    [self.contacts release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.suprafataDesen=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(IBAction)butonline
{
    suprafataDesen.butonFigura=LINE;
}

-(IBAction)butonrectangle
{
    suprafataDesen.butonFigura=RECTANGLE; 
}

-(IBAction)butonEllipse
{
    suprafataDesen.butonFigura=ELLIPSE;
}
-(IBAction)colorRed
{
    suprafataDesen.foreground=[UIColor redColor]; 
    [self.color setImage:[UIImage imageNamed:@"red_brush.png"]];
}
-(IBAction)colorBlue
{
    suprafataDesen.foreground=[UIColor blueColor];
    [self.color setImage:[UIImage imageNamed:@"blue_brush.png"]];
}
-(IBAction) colorYellow
{
    suprafataDesen.foreground=[UIColor yellowColor];
    [self.color setImage:[UIImage imageNamed:@"yellow_b.png"]];
}
-(IBAction)butonFree
{
    suprafataDesen.butonFigura=FREE;
}
-(IBAction)butonClear
{
    [suprafataDesen clear];
}
-(IBAction)backgroundRed
{
    suprafataDesen.background=[UIColor redColor];
    [self.backgroundColor setImage:[UIImage imageNamed:@"red_back.png"]];
}
-(IBAction)backgroundBlue
{
    suprafataDesen.background=[UIColor blueColor];
    [self.backgroundColor setImage:[UIImage imageNamed:@"blue_back.png"]];
}
-(IBAction)backgroundNull
{
    suprafataDesen.background=nil;
    [self.backgroundColor setImage:[UIImage imageNamed:@"black_back.png"]];
}
-(IBAction)slider:(UISlider*)sender
{
    label.text=[NSString stringWithFormat:@"%f",sender.value];
    suprafataDesen.lineWidth=sender.value;
}
/*-(IBAction)SVG
{
    [suprafataDesen writeSVG];
}*/
-(IBAction)showContacts:(id) sender
{
    UIButton *button = (UIButton*)sender;
    ContactsView *contactViewController=[[ContactsView alloc] init];
    contactViewController.contactList = self.contacts;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contactViewController];
    [popover presentPopoverFromRect:CGRectMake(button.frame.size.width / 2, button.frame.size.height / 1, 1, 1) inView:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];    
    [contactViewController release];
}
-(IBAction)test
{
    
}
-(IBAction)pdf
{
    [suprafataDesen createPDF];
}
-(IBAction)connect
{
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
		// Want xmpp to run in the background?
		// 
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    //id xmppReconnect = [[XMPPReconnect alloc] init];
    //[xmppReconnect         activate:xmppStream];
    [self connectToStream];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (BOOL)connectToStream
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = @"whiteboardapplication@gmail.com";
	NSString *myPassword = @"1lab1lab";
    
     //NSString *myJID = @"svg.xmpp@gmail.com";
    
	//
	// If you don't want to use the Settings view to set the JID, 
	// uncomment the section below to hard code a JID and password.
	// 
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	// password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting" 
		                                                    message:@"See console for error details." 
		                                                   delegate:nil 
		                                          cancelButtonTitle:@"Ok" 
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"will authenticate");
	
	//if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	//if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	/*else
     {
     // Google does things incorrectly (does not conform to RFC).
     // Because so many people ask questions about this (assume xmpp framework is broken),
     // I've explicitly added code that shows how other xmpp clients "do the right thing"
     // when connecting to a google server (gmail, or google apps for domains).
     
     NSString *expectedCertName = nil;
     
     NSString *serverDomain = xmppStream.hostName;
     NSString *virtualDomain = [xmppStream.myJID domain];
     
     if ([serverDomain isEqualToString:@"talk.google.com"])
     {
     if ([virtualDomain isEqualToString:@"gmail.com"])
     {
     expectedCertName = virtualDomain;
     }
     else
     {
     expectedCertName = serverDomain;
     }
     }
     else if (serverDomain == nil)
     {
     expectedCertName = virtualDomain;
     }
     else
     {
     expectedCertName = serverDomain;
     }
     
     if (expectedCertName)
     {
     [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
     }
     }*/
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	//isXmppConnected = YES;
	
	NSError *error = nil;
	if (![[self xmppStream] authenticateWithPassword:@"1lab1lab" error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	// [self goOnline];
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
    NSLog (@"connected and massages");
    suprafataDesen.connected=YES;
    [connectionButton setTitle:@"Connected" forState:UIControlStateNormal];
    [connectionButton setTitle:@"Connected" forState:UIControlStateSelected];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"connected, user or password error => %@", error);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	//DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
	//NSLog(@"%@", iq);
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    // NSLog(@"protocol message: %@", message);
	// A simple example of inbound message handling.
    
    //	if ([message isChatMessageWithBody])
    //	{
    //		//XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
    //		  //                                                       xmppStream:xmppStream
    //		    //                                           managedObjectContext:[self managedObjectContext_roster]];
    //		
    //		NSString *body = [[message elementForName:@"body"] stringValue];
    //		NSString *displayName = [user displayName];
    //        
    //		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    //		{
    //			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
    //                                                                message:body 
    //                                                               delegate:nil 
    //                                                      cancelButtonTitle:@"Ok" 
    //                                                      otherButtonTitles:nil];
    //			[alertView show];
    //		}
    //		else
    //		{
    //			// We are not active, so use a local notification instead
    //			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //			localNotification.alertAction = @"Ok";
    //			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
    //            
    //			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    //		}
    //	}
    // NSLog(@"%@: %@", [message from], [[message elementForName:@"body"] stringValue]);
    suprafataDesen.keyFiguri=[NSString stringWithFormat:@"%@",[message from]];
    NSArray *mesajePrimite=[message elementsForName:@"x"];
    NSString *mesajPrimit=nil;
    for( NSXMLElement *element in mesajePrimite)
    {        
        // NSLog (@"element %@ xmlns %@", element, [element attributeForName:@"xmlns"]);
        if([[[element xmlns] lowercaseString] isEqual:@"svg-whiteboard"])
        {
            for (NSXMLElement *l in [element children])
            {
                [suprafataDesen readSVGFromXmlElement:l];
            }
            //mesajPrimit=[element stringValue];
        }
    }
     if(mesajPrimit!=nil)
    {
        // [suprafataDesen readSVG:mesajPrimit];
    }
    //XMPPMessage *mesaj = [XMPPMessage message];
    
    
    //NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    //[body setStringValue:@"mesaj"];
    
    // NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    //[mesaj addAttributeWithName:@"type" stringValue:@"chat"];
    //[mesaj addAttributeWithName:@"to" stringValue:[message fromStr]];
    //[mesaj addChild:body];
    
    //[xmppStream sendElement:mesaj];
    
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	// DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    NSLog(@"%@", presence);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog (@"%@", error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"disconnected");
    suprafataDesen.connected=NO;
    suprafataDesen.connected=YES;
    [connectionButton setTitle:@"Connect" forState:UIControlStateNormal];
    [connectionButton setTitle:@"Connect" forState:UIControlStateSelected];
}
-(void) sendMessage:(shapes *)shape
{
    //NSArray *contacts=[NSArray arrayWithObjects:@"svg.xmpp@gmail.com",@"lezeca1@gmail.com", nil];
    //NSArray *contacts=[NSArray arrayWithObjects:@"whiteboardapplication@gmail.com",@"lezeca1@gmail.com", nil];
    //for(NSString *contact in self.contacts)
    for(NSString *contact in self.contacts)
    {
    XMPPMessage *mesaj = [XMPPMessage message];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x"];  
    
    [mesaj addChild:body];
    [x addAttributeWithName:@"xmlns" stringValue:@"svg-whiteboard"];
    //[x setStringValue:[NSString stringWithFormat:@"%@",[shape toSVG]]];
    NSArray *sh;
    if ([shape respondsToSelector:@selector(toSVGs)]) sh = [shape toSVGs];
    else sh = [NSArray arrayWithObjects:[shape toSVG], nil];
    
    for (id shs in sh)
    {
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:shs options:0 error:nil];
        NSXMLElement *sl = [[doc rootElement] retain];
        [sl detach];
        // [sl setValue:nil forKey:@"parent"];
        [doc release];
        [x addChild:sl];
        [sl release];
        //NSLog(@"svg data %@", shs);
    }
    
    
    //NSXMLElement *message = [NSXMLElement elementWithName:[NSString stringWithFormat:@"svg:%@",[shape toSVG]]];
    [mesaj addAttributeWithName:@"type" stringValue:@"chat"];
    [mesaj addAttributeWithName:@"from" stringValue:[[xmppStream myJID] description]]	;
    //[mesaj addAttributeWithName:@"to" stringValue:@"whiteboardapplication@gmail.com"];
    
        [mesaj addAttributeWithName:@"to" stringValue:contact];
        [mesaj addChild:x];
        [xmppStream sendElement:mesaj];
    }
}

@end
