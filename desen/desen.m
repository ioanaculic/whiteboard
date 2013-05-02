//
//  desen.m
//  desen
//
//  Created by Snow Leopard User on 21/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "desen.h"
#import "shapes.h"
#import "Line.h"
#import "DDXML.h"

@implementation desen
@synthesize figuri;
@synthesize protocol;
@synthesize touches;
@synthesize paths;
@synthesize butonFigura;
@synthesize foreground;
@synthesize background;
@synthesize lineWidth;
@synthesize connected;
@synthesize bitmap;
@synthesize keyFiguri;
@synthesize figuriDict;
-(void) setup
{
    self.figuri=[[NSMutableArray alloc]init];
    self.figuriDict=[[NSMutableDictionary alloc] init];
    self.touches=[[NSMutableArray alloc]init];
    self.connected=NO;
    self.bitmap=nil;
    self.lineWidth=2.0;
    self.butonFigura=FREE;
    self.background=nil;
    self.foreground=[UIColor redColor];
}
-(void) dealloc
{
    [self.figuri release];
    [self.touches release];
    [self.foreground release];
    [self.background release];
    [self.bitmap release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setup];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    
    for(UITouch *touch in touches)
    {
        if([self.touches count]==0) 
        {
            if (butonFigura==LINE)
            {
            Line *line=[[Line alloc] initWithColor:self.foreground lineWidth:self.lineWidth];
            [self.figuri addObject:line];
            [line release];
            }
            else if (butonFigura==RECTANGLE)
            {
            Rectangle *rectangle=[[Rectangle alloc] initWithBackground:self.background color:self.foreground lineWidth:self.lineWidth];
            [self.figuri addObject:rectangle];
            [rectangle release];
            }  
            else if (butonFigura==ELLIPSE)
            {
                Ellipse *ellipse=[[Ellipse alloc] initWithBackground:self.background color:self.foreground lineWidth:self.lineWidth];
                [self.figuri addObject:ellipse];
                [ellipse release];
            }
            else if(butonFigura==FREE)
            {
                FreeHand *freehand=[[FreeHand alloc] initWithColor:self.foreground lineWidth:self.lineWidth];
                [self.figuri addObject:freehand];
                [freehand release];
            }
            [self updateBitmap];
        }
        [self.touches addObject:touch];
    }   
    [[self.figuri lastObject]touchesBegan:self.touches withset:touches inview:self];
   // NSLog(@"touchesbegan ended");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
        {
            //NSLog(@"touchesmoved");
            [self setNeedsDisplay];
            //NSLog(@"setSelfNeedsDisplay");
            shapes *fig =[self.figuri lastObject];
            [fig touchesMoved: self.touches withset:touches inview:self];            
            if (connected==YES)
                [protocol sendMessage:fig];
        }
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
        {
            //NSLog(@"touches ended");
            [self setNeedsDisplay];
            [[self.figuri lastObject] touchesEnded: self.touches withset: touches inview:self];
            for(UITouch *touch in touches)
            {
                int i=[self.touches indexOfObject:touch];
                [self.touches removeObjectAtIndex:i];
            }
            if(connected==YES && [self.touches count]==0)
            {
                [protocol sendMessage:[self.figuri lastObject]];
            }
        }
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
        {
            [self setNeedsDisplay];
            [self.touches removeAllObjects];
            [self.figuri removeLastObject];
        }
- (void)drawRect:(CGRect)rect
{
    //NSLog (@"drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    //for (int i=0;i<[figuri count];i=i+1)
    //{
        //[[figuri objectAtIndex:i]draw:context]; 
    //}
    CGContextDrawImage(context, self.bounds, self.bitmap.CGImage);
    [[figuri lastObject] draw:context];
}

-(void) clear
{
    [self.figuri removeAllObjects];
    [self setNeedsDisplay];
    [self updateBitmap];

}
-(void)writeSVG
{
    for(int i=0; i<[figuri count]; i=i+1)
    {
        
        
        
        //NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        //[body setStringValue:@"mesaj"];
        
        // NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        //[mesaj addAttributeWithName:@"type" stringValue:@"chat"];
        //[mesaj addAttributeWithName:@"to" stringValue:[message fromStr]];
        //[mesaj addChild:body];
        
        //[xmppStream sendElement:mesaj];

        //NSLog(@"%@",[[figuri objectAtIndex:i] toSVG]);
    }
}
-(void)readSVGFromXmlElement:(NSXMLElement *)l
{
    [self setNeedsDisplay];
    shapes *fig=nil;
    NSString *figure=[[l name] lowercaseString];
    if([figure isEqual:@"line"])
        fig=(Line*)[Line toFigure:l];
    else if ([figure isEqual:@"ellipse"])
        fig=(Ellipse*)[Ellipse toFigure:l];
    else if ([figure isEqual:@"rect"])
        fig=(Rectangle*)[Rectangle toFigure:l];
    else if ([figure isEqual:@"polyline"])
        fig=(FreeHand*)[FreeHand toFigure:l];    
    
    self.keyFiguri=[keyFiguri stringByAppendingString:[NSString stringWithFormat:@"%d",fig.identifier]];
    shapes *receievedFigure=[self.figuriDict objectForKey:self.keyFiguri];
    if(receievedFigure==nil)
    {
        [self.figuriDict setObject:fig forKey:self.keyFiguri];
        if([self.figuri count]>0)
        {
            int i=[self.figuri count]-1;
            [self.figuri insertObject:fig atIndex:i];
        }
        else [self.figuri addObject:fig];
    }
    else
    {
        [receievedFigure updateFigure:l];
    }
    [self updateBitmap];
}
-(void)readSVG:(NSString *) string
{
    [self setNeedsDisplay];
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    NSXMLElement *root = [doc rootElement];
    [doc release];
    [self readSVGFromXmlElement:root];
}
-(void) updateBitmap
{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent=8;
    size_t bytesPerPixel=4;
    size_t bytesPerRow=(self.bounds.size.width*bitsPerComponent*bytesPerPixel+7)/8;
    CGContextRef context=CGBitmapContextCreate(NULL, self.bounds.size.width,self.bounds.size.height, bitsPerComponent,bytesPerRow,colorSpace,kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    if([figuri count]>0)
    {
    for (int i=0;i<[figuri count]-1;i=i+1)
        {
           [[figuri objectAtIndex:i]draw:context]; 
        }
    }
    CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef=CGBitmapContextCreateImage(context);
    self.bitmap=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
}
-(void) createPDF
{
    NSMutableData *pdfData=[NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, self.bounds , nil);
    UIGraphicsBeginPDFPage();
    [self drawRect:self.bounds];
    UIGraphicsEndPDFContext();
    MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
    mailComposer.mailComposeDelegate = self;
    [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"Dude creation.pdf"];
    [self.protocol presentModalViewController:mailComposer animated:YES];    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}
@end
