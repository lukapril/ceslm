//
//  IODEventReminderTableViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-29.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface IODEventReminderTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) EKEventStore *eventStore;

@property (strong, nonatomic) NSString *eventNameString;
@property (strong, nonatomic) NSIndexPath *eventIndexPath;
@property (nonatomic, strong) NSMutableArray *eventDateList;
@property (nonatomic, strong) NSMutableArray *eventDurationList;
@property (nonatomic, strong) NSMutableArray *eventLocationList;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (void) buildEventList:(NSString *)targetEventType;
- (IBAction)doneSetReminder:(id)sender;
- (IBAction)cancelSetReminder:(id)sender;

@end
