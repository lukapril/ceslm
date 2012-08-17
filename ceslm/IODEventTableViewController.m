//
//  IODEventTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-14.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODEventTableViewController.h"
#import "EventDetailTableCell.h"
#import "SVProgressHUD.h"

@interface IODEventTableViewController ()

@end

@implementation IODEventTableViewController
{
    dispatch_queue_t backgroundQueue;
//    UIActivityIndicatorView *spinner;
}

@synthesize selectedEvent;
@synthesize eventList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) buildEventList:(NSString *)targetEventType{
        
    NSString *targetEventUrlString = [[NSString stringWithFormat:@"%@%@.json", EVENT_BASE_URL, targetEventType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    dispatch_async(backgroundQueue, ^(void) {
        [SVProgressHUD show];
        
        NSError *jsonError;
        NSString *jsonFile = [[NSBundle mainBundle] pathForResource:targetEventType ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];

//        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:targetEventUrlString]];
//        NSError *jsonError;
        
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
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:19];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 2;
    label.text = selectedEvent;
    self.navigationItem.titleView = label;

    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }

- (void)viewDidAppear:(BOOL)animated
{
    backgroundQueue = dispatch_queue_create("eventData.bgqueue", NULL);
    [self buildEventList:selectedEvent];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"EventDetailTableCell";
    EventDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    cell.eventName.text = [eventItem valueForKey:@"name"];
    cell.eventName.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventName.numberOfLines = 0;
    cell.eventName.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    CGRect labelFrame = cell.eventName.frame;
    labelFrame.size.width = 280;
    cell.eventName.frame = labelFrame;
    [cell.eventName sizeToFit];
            
    cell.eventDescription.text = [eventItem valueForKey:@"description"];
    cell.eventDescription.lineBreakMode = UILineBreakModeWordWrap;
    cell.eventDescription.numberOfLines = 0;
    cell.eventDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    labelFrame = cell.eventDescription.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.eventName.frame.size.height + cell.eventName.frame.origin.y + 10.0f;
    cell.eventDescription.frame = labelFrame;
    [cell.eventDescription sizeToFit];
    
    cell.eventContactHeader.text = @"For more information...";
    cell.eventContactHeader.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    labelFrame = cell.eventContactHeader.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.eventDescription.frame.size.height + cell.eventDescription.frame.origin.y + 10.0f;
    cell.eventContactHeader.frame = labelFrame;
    [cell.eventContactHeader sizeToFit];
    
    cell.eventContactText.editable = NO;
    cell.eventContactText.backgroundColor = [UIColor clearColor];
    cell.eventContactText.text = [eventItem valueForKey:@"contact"];
    cell.eventContactText.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    labelFrame = cell.eventContactText.frame;
    labelFrame.size.width = 290;
    labelFrame.origin.y = cell.eventContactHeader.frame.size.height + cell.eventContactHeader.frame.origin.y + 3.0f;
    cell.eventContactText.frame = labelFrame;
    [cell.eventContactText sizeToFit];
    
    cell.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stitching"]]];
    
    return cell;

}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *eventItem = [eventList objectAtIndex:indexPath.row];
    
    NSString *eventText = [eventItem valueForKey:@"name"];
    float eventHeight = [eventText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSString *descriptionText = [eventItem valueForKey:@"description"];
    float descriptionHeight = [descriptionText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;

    NSString *contactHeaderText = @"For more information...";
    float contactHeaderTextHeight = [contactHeaderText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSString *contactText = [eventItem valueForKey:@"contact"];
    float contactTextHeight = [contactText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    
    return eventHeight + descriptionHeight + contactHeaderTextHeight + contactTextHeight + 70.0f;
}

@end
