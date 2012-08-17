//
//  IODLocationTableViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-14.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODLocationTableViewController.h"
#import "LocationTableCell.h"


@interface IODLocationTableViewController ()

@end

@implementation IODLocationTableViewController

@synthesize locationList;
@synthesize targetLocation;

- (void) buildLocationList {
    
    NSError *jsonError;
//    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"ChurchDetails" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];

    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHURCH_DETAILS_JSON]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    
    NSArray *jsonArray = [json objectForKey:@"placemark"];
    self.locationList = jsonArray;
    
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
    
    [self buildLocationList];
    
    NSInteger rowNumber = [self findRowNumberWithText:targetLocation];
    NSIndexPath * rowAtIndexPath = [NSIndexPath indexPathForRow:rowNumber inSection:0];
    [self.tableView scrollToRowAtIndexPath:rowAtIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
    
    self.title = @"Location Lists";    
    
//    // reverse geo-code and get address
//    __block NSString *addressString;
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:51.13693600 longitude:-114.15750100];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
//        //cell.locationAddress.text = [NSString stringWithFormat:@"%d %@",indexPath.row, [error description]];
//        if (error){
//            NSLog(@"Geocode failed with error: %@", error);
//            return;
//        }
//        if(placemarks && placemarks.count > 0)
//        {
//            CLPlacemark *topResult = [placemarks objectAtIndex:0];
//            addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", [topResult subThoroughfare], [topResult thoroughfare], [topResult locality], [topResult administrativeArea]];
//            NSLog(@"address: %@", addressString);
//            
//        } 
//    }];   
}

- (void)viewDidAppear:(BOOL)animated
{
    [locationTableView reloadData];
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
    cell.locationName.lineBreakMode = UILineBreakModeWordWrap;
    cell.locationName.numberOfLines = 0;
    CGRect labelFrame = cell.locationName.frame;
    labelFrame.size.width = 280;
    cell.locationName.frame = labelFrame;
    [cell.locationName sizeToFit];
    
    cell.locationDescription.text = [locationItem valueForKey:@"description"];
    cell.locationDescription.lineBreakMode = UILineBreakModeWordWrap;
    cell.locationDescription.numberOfLines = 0;
    labelFrame = cell.locationDescription.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.locationName.frame.size.height + cell.locationName.frame.origin.y + 10.0f;
    cell.locationDescription.frame = labelFrame;
    [cell.locationDescription sizeToFit];
        
    // --- reverse-geocoding address
    NSLog(@"Coordinates are: %@", [[locationItem objectForKey:@"point"] valueForKey:@"coordinates"]); 
    
    NSArray *coordsPair = [[[locationItem objectForKey:@"point"] valueForKey:@"coordinates"] componentsSeparatedByString:@","];
    NSString *_lat = [coordsPair objectAtIndex:0];
    NSString *_long = [coordsPair objectAtIndex:1];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_long doubleValue] longitude:[_lat doubleValue]];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        cell.locationAddress.text = [NSString stringWithFormat:@"%d %@",indexPath.row, [error description]];
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if(placemarks && placemarks.count > 0)
        {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            cell.locationAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@ ", [topResult subThoroughfare], [topResult thoroughfare], [topResult locality], [topResult administrativeArea]];    
            cell.locationAddress.lineBreakMode = UILineBreakModeWordWrap;
            cell.locationAddress.numberOfLines = 0;
            CGRect labelFrame = cell.locationAddress.frame;
            labelFrame.size.width = 280;
            labelFrame.origin.y = cell.locationDescription.frame.size.height + cell.locationDescription.frame.origin.y + 10.0f;
            cell.locationAddress.frame = labelFrame;
            [cell.locationAddress sizeToFit];
        } 
    }];    

    [cell.locationWebsiteButton setTitle:[locationItem valueForKey:@"website"] forState:UIControlStateNormal];
    labelFrame = cell.locationWebsiteButton.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = cell.locationDescription.frame.origin.y + cell.locationDescription.frame.size.height + 10.0f;
    if (cell.locationAddress.text != nil) {
        labelFrame.origin.y = labelFrame.origin.y + cell.locationAddress.frame.size.height + 10.0f;
    }
    cell.locationWebsiteButton.frame = labelFrame;
    [cell.locationWebsiteButton sizeToFit];

    cell.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorColor:[UIColor blackColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *locationItem = [locationList objectAtIndex:indexPath.row];
    
    NSString *locationText = [locationItem valueForKey:@"name"];
    float locationTextHeight = [locationText sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    NSString *descriptionText = [locationItem valueForKey:@"description"];
    float descriptionTextHeight = [descriptionText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
        
    NSString* addressText = [[locationItem objectForKey:@"point"] valueForKey:@"coordinates"];
    float addressTextHeight = [addressText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
    
    float cellHeight = locationTextHeight + descriptionTextHeight + 70.0f;
    
    if ([locationItem valueForKey:@"website"] != nil) {
        cellHeight = cellHeight + 35.0f;
    }

    return cellHeight;
}

@end
