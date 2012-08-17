//
//  IODSetEventReminderViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-26.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface IODSetEventReminderViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) EKEventStore *eventStore;

@property (strong, nonatomic) NSString *eventNameString;
@property (strong, nonatomic) NSIndexPath *eventIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmReminder:(id)sender;
- (IBAction)Done:(id)sender;

@end
