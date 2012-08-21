//
//  IODUpcomingEventTableViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface IODUpcomingEventTableViewController : UITableViewController 


@property (nonatomic, retain) NSString *selectedEventType;
@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) EKEventStore *eventStore;

@property (strong, nonatomic) NSString *targetEventName;
@property (strong, nonatomic) NSIndexPath *targetEventIndexPath;


- (void) buildEventList;
- (IBAction)registerEvent:(id)sender;
- (IBAction)setEventReminder:(id)sender;

@end
