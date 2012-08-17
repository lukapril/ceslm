//
//  IODEventTypeTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-11.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODEventTypeTableViewController.h"
#import "EventType.h"
#import "IODEventTableViewController.h"
#import "IODUpcomingEventTableViewController.h"

@interface IODEventTypeTableViewController ()

@end

@implementation IODEventTypeTableViewController

@synthesize eventTypes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) buildEventTypesList {    
    
    NSError *jsonError;
    NSLog(@"DEBUG: Building event list...");
//    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"EventTypes" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
    
//    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:EVENT_TYPES_JSON]];
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
//    NSMutableArray *eventTypesList = [json objectForKey:@"EventTypes"];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jsonFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"EventTypes.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath options:kNilOptions error:&jsonError];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    NSMutableArray *eventTypesList = [json objectForKey:@"EventTypes"];

    
//    NSLog(@"There are total %d elements in the jsonArray", [eventTypesList count]);
//    for (NSString *element in eventTypesList) {
//        NSLog(@"element: %@", element);
//    }

    eventTypes = [[NSMutableArray alloc]init];
    
    for (int aIndex=0; aIndex < [eventTypesList count]; aIndex++) {
        EventType *aEvent = [[EventType alloc] init];
        aEvent.name = [[eventTypesList objectAtIndex:aIndex] objectForKey:@"name"];
        aEvent.shortDescription = [[eventTypesList objectAtIndex:aIndex] objectForKey:@"description"];
        [eventTypes addObject:aEvent];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Events";
    self.navigationItem.titleView = label;

    
    [self buildEventTypesList];    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    UIImage *gradientImage44 = [[UIImage imageNamed:@"surf_gradient_textured_44"] 
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 
                                       forBarMetrics:UIBarMetricsDefault];
    
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
    return [self.eventTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    EventType *aEvent = [self.eventTypes objectAtIndex:indexPath.row];
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    cell.textLabel.text = aEvent.name;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.detailTextLabel.text = aEvent.shortDescription;
 
    cell.backgroundColor = [UIColor clearColor];
//    [tableView setSeparatorColor:[UIColor blackColor]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(indexPath.row == 0)
        [self performSegueWithIdentifier:@"showUpcomingEvents" sender:self];
    else {
        [self performSegueWithIdentifier:@"showEvents" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUpcomingEvents"]) {
        // Get destination view
        IODUpcomingEventTableViewController *targetViewController = [segue destinationViewController];
        
        // Get the selected row name
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];        
        NSString *selectedRowName = [self.tableView cellForRowAtIndexPath:selectedRow].textLabel.text;
        NSLog(@"%@", selectedRowName);
        
        // Pass the information to the destination view
        targetViewController.selectedEventType = selectedRowName;
    }
    else {
        // Get destination view
        IODEventTableViewController *targetViewController = [segue destinationViewController];
        
        // Get the selected row name
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];        
        NSString *selectedRowName = [self.tableView cellForRowAtIndexPath:selectedRow].textLabel.text;
        NSLog(@"%@", selectedRowName);
        
        // Pass the information to the destination view
        targetViewController.selectedEvent = selectedRowName;
    }
}

@end
