//
//  IODLocationTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-14.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import "IODLocationTableViewController.h"
#import "LocationTableCell.h"


@interface IODLocationTableViewController ()

@end

@implementation IODLocationTableViewController

@synthesize locationName;
@synthesize locationAddress;
@synthesize locationList;
@synthesize targetLocation;

- (void) buildLocationList {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Church Details Information";
    self.navigationItem.titleView = label;
    
    NSError *jsonError;
    NSData *jsonData;
    
    if (ENV == @"PROD") {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *jsonFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ChurchDetails.json"];
        jsonData = [NSData dataWithContentsOfFile:jsonFilePath options:kNilOptions error:&jsonError];
    }
    else {
        NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"ChurchDetails" ofType:@"json"];
        jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    NSArray *jsonArray = [json objectForKey:@"placemark"];
    self.locationList = jsonArray;
    NSDictionary *locationItem = [locationList objectAtIndex:[self findRowNumberWithText:targetLocation]];
    
    //    NSLog(@"There are total %d elements in the list", [jsonArray count]);
    //    for (NSString *element in jsonArray) {
    //        NSLog(@"element: %@", element);
    //    }    

}

- (NSInteger) findRowNumberWithText: (NSString *)text{
    for (int index = 0; index < [locationList count]; index++) {
        NSString *actualName = [[locationList objectAtIndex:index] valueForKey:@"name"];
        if ([actualName isEqualToString:text]) {
            return index;
        }
    }
    return nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    label.text = @"Calgary Church ESL Programs";
    self.navigationItem.titleView = label;
     
    [self buildLocationList];
    
    NSInteger rowNumber = [self findRowNumberWithText:targetLocation];
    NSIndexPath * rowAtIndexPath = [NSIndexPath indexPathForRow:rowNumber inSection:0];
    [self.tableView scrollToRowAtIndexPath:rowAtIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [locationTableView reloadData];
}

- (void)viewDidUnload
{
    [self setLocationName:nil];
    [self setLocationAddress:nil];
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
    return [locationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    LocationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[LocationTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];         
    }    
    
    // Configure the cell...
    NSDictionary *locationItem = [locationList objectAtIndex:indexPath.row];
        
    cell.locationName.text = [locationItem valueForKey:@"name"];
    cell.locationName.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
    cell.locationName.lineBreakMode = UILineBreakModeWordWrap;
    cell.locationName.numberOfLines = 0;
    CGRect labelFrame = cell.locationName.frame;
    labelFrame.size.width = 280;
    cell.locationName.frame = labelFrame;
    [cell.locationName sizeToFit];
    
    cell.locationAddress.text = [locationItem valueForKey:@"address"];
    cell.locationAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.locationAddress.lineBreakMode = UILineBreakModeWordWrap;
    cell.locationAddress.numberOfLines = 0;
    labelFrame = cell.locationAddress.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.locationName.frame.size.height + cell.locationName.frame.origin.y + 3.0f;
    cell.locationAddress.frame = labelFrame;
    [cell.locationAddress sizeToFit];

    cell.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorColor:[UIColor blackColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *locationItem = [locationList objectAtIndex:indexPath.row];
    
    NSString *locationText = [locationItem valueForKey:@"name"];
    float locationTextHeight = [locationText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
            
    NSString* addressText = [locationItem objectForKey:@"address"];
    float addressTextHeight = [addressText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    float cellHeight = locationTextHeight + addressTextHeight + 30.0f;
    
return cellHeight;
}

@end
