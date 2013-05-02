//
//  ContactsView.h
//  desen
//
//  Created by Snow Leopard User on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsView : UIViewController<UITabBarDelegate, UITableViewDataSource>
@property(nonatomic, retain) NSMutableArray *contactList; 
-(IBAction)editContacts;
-(IBAction)addContacts;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *edit;
@property (nonatomic, retain) IBOutlet UIButton *add;
@property (nonatomic, retain) IBOutlet UITextField *contact;
-(IBAction)addContact;
-(IBAction)doneContact;
@end
