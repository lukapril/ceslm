//
//  IODUpcomingEventTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODUpcomingEventTableViewController.h"
#import "EventDetailTableCell.h"
#import "IODRegisterEventViewController.h"
#import "IODEventReminderTableViewController.h"
#import "SVProgressHUD.h"

@interface IODUpcomingEventTableViewController ()

@end

@implementation IODUpcomingEventTableViewController
{
    dispatch_queue_t backgroundQueue;
//    UIActivityIndicatorView *spinner;
}

@synthesize targetEventName;
@synthesize targetEventIndexPath;
@synthesize selectedEventType;
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
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
//            [spinner stopAnimating];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = selectedEventType;
    self.navigationItem.titleView = label;
        
    [self.tableView reloadData];
    eventStore = [[EKEventStore alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    backgroundQueue = dispatch_queue_create("eventData.bgqueue", NULL);
//    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(110, 200, 100.0, 100.0)];
//    spinner.center = self.view.center;
//    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
    
    [self buildEventList:selectedEventType];
    
//    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return [self.eventList count];
}

// This is for Upcoming Events Only
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventDetailTableCell";
    EventDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    cell.eventName.text = [eventItem valueForKey:@"name"];
    cell.eventName.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    cell.eventName.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventName.numberOfLines = 0;
    CGRect labelFrame = cell.eventName.frame;
    labelFrame.size.width = 280;
    cell.eventName.frame = labelFrame;
    [cell.eventName sizeToFit];
    
    cell.eventDescription.text = [eventItem valueForKey:@"description"];
    cell.eventDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    cell.eventDescription.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventDescription.numberOfLines = 0;
    labelFrame = cell.eventDescription.frame;
    labelFrame.size.width = 280;
    cell.eventDescription.frame = labelFrame;
    [cell.eventDescription sizeToFit];

    
    NSMutableString *eventsDateLocation = [NSMutableString string];
    
    for (int itemIndex=0; itemIndex < [[eventItem objectForKey:@"event date"] count]; itemIndex++) {
        NSString *itemDate = [[eventItem objectForKey:@"event date"] objectAtIndex:itemIndex];
        NSString *itemLoation = [[eventItem objectForKey:@"event location"] objectAtIndex:itemIndex];
        
        [eventsDateLocation appendFormat:@"%@ @ %@ \n\n", itemDate, itemLoation];
    }

    cell.eventDate.text = eventsDateLocation;
    cell.eventDate.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:13];
    if ([cell.eventDate.text contains:@"TBD @ TBD"]) {
        cell.eventDate.text = @"Events date and location details coming soon!";
    }
    cell.eventDate.textColor = [UIColor darkGrayColor];
    cell.eventDate.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventDate.numberOfLines = 0;
    labelFrame = cell.eventDate.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.eventDescription.frame.size.height + cell.eventDescription.frame.origin.y + 15.0f;
    cell.eventDate.frame = labelFrame;
    [cell.eventDate sizeToFit];
    
    cell.eventContactHeader.text = @"For more information...";
    cell.eventContactHeader.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    labelFrame = cell.eventContactHeader.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.eventDate.frame.size.height + cell.eventDate.frame.origin.y + 14.0f;
    cell.eventContactHeader.frame = labelFrame;
    [cell.eventContactHeader sizeToFit];

    cell.eventContact.text = [eventItem valueForKey:@"contact"];
    cell.eventContact.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    cell.eventContact.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventContact.numberOfLines = 0;
    labelFrame = cell.eventContact.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.eventContactHeader.frame.size.height + cell.eventContactHeader.frame.origin.y + 10.0f;
    cell.eventContact.frame = labelFrame;
    [cell.eventContact sizeToFit];
    
    cell.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stitching"]]];
    
    return cell;
}

// This is for Upcoming Events Only
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    NSString *eventText = [eventItem valueForKey:@"name"];
    float eventHeight = [eventText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSString *descriptionText = [eventItem valueForKey:@"description"];
    float descriptionHeight = [descriptionText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSMutableString *eventsDateLocation = [NSMutableString string];
    for (int itemIndex=0; itemIndex < [[eventItem objectForKey:@"event date"] count]; itemIndex++) {
        NSString *itemDate = [[eventItem objectForKey:@"event date"] objectAtIndex:itemIndex];
        NSString *itemLoation = [[eventItem objectForKey:@"event location"] objectAtIndex:itemIndex];
        
        [eventsDateLocation appendFormat:@"%@ @ %@ \n\n", itemDate, itemLoation];
    }
    float eventsDateLocationHeight = [eventsDateLocation sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:13] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSString *contactHeaderText = @"For more information...";
    float contactHeaderTextHeight = [contactHeaderText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;

    NSString *contactText = [eventItem valueForKey:@"contact"];
    float contactTextHeight = [contactText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;

    return eventHeight + descriptionHeight + eventsDateLocationHeight + contactHeaderTextHeight + contactTextHeight + 150.0f;
}


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"registerEvent"]) {        
        NSLog(@"trying to register for event %@ ", targetEventName);
        
        // Get destination view
        UINavigationController *targetVC = [segue destinationViewController];        
        IODRegisterEventViewController *targetViewController = [targetVC topViewController];
        
        // Pass the information to the destination view   
        targetViewController.eventNameString = targetEventName;
    }
    else if ([[segue identifier] isEqualToString:@"setReminderEvent"]) {        
        NSLog(@"trying to set reminder for event %@", targetEventName);
        
        // Get destination view
        UINavigationController *targetVC = [segue destinationViewController];        
        IODEventReminderTableViewController *targetViewController = [targetVC topViewController];

        // Pass the information to the destination view   
        targetViewController.eventNameString = targetEventName;
        targetViewController.eventIndexPath = targetEventIndexPath;

    }
}

- (IBAction)setEventReminder:(id)sender {    
    EventDetailTableCell *cell = (EventDetailTableCell *)[[sender superview] superview];      
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    //case for event has multiple dates (assume dates will NOT be TBD if there are multiple dates)
    if ([[eventItem objectForKey:@"event date"] count] > 1) {
        targetEventName = [eventItem valueForKey:@"name"];
        targetEventIndexPath = [self.tableView indexPathForCell:cell];
        [self performSegueWithIdentifier:@"setReminderEvent" sender:self];
    }
    else if ([[eventItem objectForKey:@"event date"] count] == 1) {
        // case for event has 1 date but TBD, show alert
        if ([[[eventItem objectForKey:@"event date"] objectAtIndex:0] contains:@"TBD"]) {
            UIAlertView *alert = [UIAlertView alloc];
            alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We cannot add event reminder because we have not determine the date for the event just yet. Please come back and check for updates later." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        } 
        // case for event has 1 known date, direct user to set reminder
        else {
            targetEventName = [eventItem valueForKey:@"name"];
            targetEventIndexPath = [self.tableView indexPathForCell:cell];
            [self performSegueWithIdentifier:@"setReminderEvent" sender:self];
        }
    }
    // case for event no date specified yet, show alert
    else {
        UIAlertView *alert = [UIAlertView alloc];
        alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We cannot add event reminder because we have not determine the date for the event just yet. Please come back and check for updates later." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }   
}

- (IBAction)registerEvent:(id)sender {
    EventDetailTableCell *cell = (EventDetailTableCell *)[[sender superview] superview];      
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    //case for event has multiple dates (assume dates will NOT be TBD if there are multiple dates)
    if ([[eventItem objectForKey:@"event date"] count] > 1) {
        targetEventName = [eventItem valueForKey:@"name"];
        [self performSegueWithIdentifier:@"registerEvent" sender:self];
    }
    else if ([[eventItem objectForKey:@"event date"] count] == 1) {
        NSString *eventDateString = [[eventItem objectForKey:@"event date"] objectAtIndex:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
        NSDate* currentDate = [NSDate date];
        
        // Use the user's current calendar and time zone
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [calendar setTimeZone:timeZone];
        
        // Selectively convert the date components (year, month, day) of the input date
        NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:eventDate];
        
        // Set the time components manually
        [dateComps setHour:0];
        [dateComps setMinute:0];
        [dateComps setSecond:0];
        
        // Convert back
        NSDate *eventDateForComp = [calendar dateFromComponents:dateComps];
        
        NSComparisonResult result = [eventDateForComp compare:currentDate];
                
        // case for event has 1 date but TBD, show alert
        if ([[[eventItem objectForKey:@"event date"] objectAtIndex:0] contains:@"TBD"]) {
            UIAlertView *alert = [UIAlertView alloc];
            alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We do no accept registeration just yet. Please come back and check for updates later." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        // case for event in the past or same day as event, show alert
        else if (result <= 0) {
            UIAlertView *alert = [UIAlertView alloc];
            alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Thank you for your interested, but we have closed registeration for this event." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }            
        // case for event has 1 known date, direct user to set reminder
        else {
            // case for event in the past or same day as event, show alert
            if (result <= 0) {
                UIAlertView *alert = [UIAlertView alloc];
                alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Thank you for your interested, but we have closed registeration for this event." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
            else {
                targetEventName = [eventItem valueForKey:@"name"];
                [self performSegueWithIdentifier:@"registerEvent" sender:self];
            }
        }
    }
    // case for event no date specified yet, show alert
    else {
        UIAlertView *alert = [UIAlertView alloc];
        alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We do no accept registeration just yet. Please come back and check for updates later." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }    
}

@end
