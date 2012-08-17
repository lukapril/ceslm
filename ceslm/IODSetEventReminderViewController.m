//
//  IODSetEventReminderViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-26.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODSetEventReminderViewController.h"

@interface IODSetEventReminderViewController ()

@end

@implementation IODSetEventReminderViewController

@synthesize eventNameString;
@synthesize eventIndexPath;
@synthesize eventName;
@synthesize confirmButton;
@synthesize eventList;
@synthesize eventStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) buildEventList:(NSString *)targetEventType{
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:targetEventType ofType:@"json"];
    NSError *jsonError;
    
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    
    NSArray *jsonArray = [json objectForKey:targetEventType];
    self.eventList = jsonArray;
    
    //    NSLog(@"There are total %d elements in the eventList", [self.eventList count]);
    //    for (NSString *element in self.eventList) {
    //        NSLog(@"element: %@", element);
    //    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    eventName.text = eventNameString;
    eventName.lineBreakMode = UILineBreakModeWordWrap;
    eventName.numberOfLines = 0;
    
    [self buildEventList:@"Upcoming Events"];
}

- (void)viewDidUnload
{
    [self setEventName:nil];
    [self setConfirmButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)confirmReminder:(id)sender {
    NSDictionary *eventItem = [eventList objectAtIndex:eventIndexPath.row];
    
    NSString *eventTitle = [eventItem valueForKey:@"name"];    
    
    NSLog(@"Number of dates for the selected event: %d", [[eventItem objectForKey:@"event date"] count]);
    
    // TODO: Need to setup a view here to show available event dates
    
    NSString *eventLocation = [[eventItem objectForKey:@"event location"] objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *eventDate = [dateFormatter dateFromString:[[eventItem objectForKey:@"event date"] objectAtIndex:0]];
    
    
    NSLog(@"Selected event: %@ : %@ : %@", eventTitle, eventDate, eventLocation);
    
    NSPredicate *predicateForEvent = [eventStore predicateForEventsWithStartDate:eventDate endDate:[eventDate dateByAddingTimeInterval:600] calendars:nil];
    NSArray *matchedEvents = [eventStore eventsMatchingPredicate:predicateForEvent];
    
    BOOL eventExists = NO;
//    for (EKEvent *eventToCheck in matchedEvents) {
//        if ([eventToCheck.title isEqualToString:eventTitle]) {
//            eventExists = YES;
//        }
//    }
    
    if (eventExists == NO) {
        EKEvent *addEvent=[EKEvent eventWithEventStore:eventStore];
        addEvent.title=eventTitle;
        addEvent.startDate=eventDate;
        addEvent.endDate=[addEvent.startDate dateByAddingTimeInterval:600];
        addEvent.location=eventLocation;
        [addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:addEvent.startDate]];
        NSError *err;
        [eventStore saveEvent:addEvent span:EKSpanThisEvent commit:YES error:&err];
        
        if (err != nil) {
            UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to add the event to the calender." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        else {
            UIAlertView* successAlert = [[UIAlertView alloc] initWithTitle:@"Event added" message:@"Event was added to your calender successfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [successAlert show];
        }
    }
    else {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Event already existed" message:[NSString stringWithFormat:@"Event '%@' already added in your calender.", eventTitle] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
        
    }
}

- (IBAction)Done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
