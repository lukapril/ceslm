//
//  IODEventReminderTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-29.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODEventReminderTableViewController.h"
#import "SVProgressHUD.h"

@interface IODEventReminderTableViewController ()

@end

@implementation IODEventReminderTableViewController {
    NSMutableArray *selectedIndexList;
    dispatch_queue_t backgroundQueue;
}

@synthesize eventNameString;
@synthesize eventIndexPath;
@synthesize eventDateList;
@synthesize eventDurationList;
@synthesize eventLocationList;
@synthesize doneButton;
@synthesize cancelButton;

@synthesize eventList;
@synthesize eventStore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) buildEventList:(NSString *)targetEventType{
    dispatch_async(backgroundQueue, ^(void) {
        [SVProgressHUD show];
        
        NSError *jsonError;
        NSData *jsonData;
        
        if (ENV == @"PROD") {
            NSString *targetEventUrlString = [[NSString stringWithFormat:@"%@%@.json", EVENT_BASE_URL, targetEventType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:targetEventUrlString]];
        }
        else {
            NSString *jsonFile = [[NSBundle mainBundle] pathForResource:targetEventType ofType:@"json"];
            jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
        }
        
        // Convert to dictionary or array here
        if (jsonData != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
            NSArray *jsonArray = [json objectForKey:targetEventType];
            self.eventList = jsonArray;
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to load Events details. There may be some network error. Please try again later " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Pass that array to the UI, set a local property, then update your UI here since its on the main thread
            NSDictionary *eventItem = [self.eventList objectAtIndex:eventIndexPath.row];
            self.eventDateList = [eventItem objectForKey:@"event date"];
            self.eventDurationList = [eventItem objectForKey:@"event duration"];
            self.eventLocationList = [eventItem objectForKey:@"event location"];

            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    selectedIndexList = [NSMutableArray array];
    eventStore = [[EKEventStore alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Set Reminder";
    self.navigationItem.titleView = label;

    backgroundQueue = dispatch_queue_create("eventData.bgqueue", NULL);
    [self buildEventList:@"Upcoming Events"];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setDoneButton:nil];
    [self setCancelButton:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [eventDateList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return eventNameString;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Select which event date and location you would like to set reminder for.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventReminderTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
    cell.textLabel.text = [eventDateList objectAtIndex:indexPath.row];  
    
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [eventLocationList objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableView setSeparatorColor:[UIColor blackColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    float eventDateHeight = [[eventDateList objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18] constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    float eventLocationHeight = [[eventLocationList objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    return eventDateHeight + eventLocationHeight + 20.0f;
}



//#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text contains:@"TBD"] || [cell.textLabel.text contains:@"coming soon"]) {
        return;
    }
    else {
        [selectedIndexList addObject:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
//    NSLog(@"There are total %d elements in the selectedIndexList", [selectedIndexList count]);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedIndexList removeObject:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
            
//    NSLog(@"There are total %d elements in the selectedIndexList", [selectedIndexList count]);
}


- (IBAction)doneSetReminder:(id)sender {
    
    if ([selectedIndexList count] == 0) {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select at least one event for reminder setting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
    }
    else {
        
        for (NSIndexPath *path in selectedIndexList) {     
            
            NSError *err;
            
            NSString *eventDateString = [self.tableView cellForRowAtIndexPath:path].textLabel.text;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
            NSString *eventLocation = [self.tableView cellForRowAtIndexPath:path].detailTextLabel.text;
            
            NSPredicate *predicateForEvent = [eventStore predicateForEventsWithStartDate:eventDate endDate:[eventDate dateByAddingTimeInterval:600] calendars:nil];
            NSArray *matchedEvents = [eventStore eventsMatchingPredicate:predicateForEvent];
            
            BOOL eventExists = NO;
            for (EKEvent *eventToCheck in matchedEvents) {
                if ([eventToCheck.title isEqualToString:eventNameString]) {
                    eventExists = YES;
                }
            }
            
            if (eventExists == NO) {
                EKEvent *addEvent = [EKEvent eventWithEventStore:eventStore];
                addEvent.title = eventNameString;
                addEvent.startDate = eventDate;
                NSString *eventDurationString = [eventDurationList objectAtIndex:path.row];
                NSLog(@"eventDurationString is %@", eventDurationString);
                
                double eventDuration = 300;
                if (![eventDurationString contains:@"TBD"]) {
                    eventDuration = [eventDurationString doubleValue];
                }
                                
                NSLog(@"eventDuration is %f", eventDuration);
                addEvent.endDate = [addEvent.startDate dateByAddingTimeInterval:eventDuration];
                addEvent.location = eventLocation;
                [addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
                addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:addEvent.startDate]];
                
                [eventStore saveEvent:addEvent span:EKSpanThisEvent commit:YES error:&err];
                
                if (err != nil) {
                    UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to add the event to the calender. There may be some network error. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorAlert show];
                }
                else {
                    [self dismissModalViewControllerAnimated:YES];
                }
                
            }
            else {
                [self dismissModalViewControllerAnimated:YES];
            }
        }
    }
}

- (IBAction)cancelSetReminder:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
