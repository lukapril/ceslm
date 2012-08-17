//
//  IODLocationDetailsScrollViewController.m
//  ceslm
//
//  Created by April Luk on 12-08-16.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODLocationDetailsScrollViewController.h"

@interface IODLocationDetailsScrollViewController ()

@end

@implementation IODLocationDetailsScrollViewController

@synthesize locationList;
@synthesize targetLocation;
@synthesize locationName;
@synthesize locationAddressString;
@synthesize locationDescription;
@synthesize locationContactHeader;
@synthesize locationContact;
@synthesize locationWebsiteButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger) findRowNumberWithText: (NSString *)text{
    for (int index = 0; index < [locationList count]; index++) {
        NSString *actualName = [[locationList objectAtIndex:index] valueForKey:@"name"];
        if ([actualName isEqualToString:text]) {
            return index;
        }
    }
    return 0;
}

- (IBAction)goToUrl:(id)sender {
    NSString* targetUrl = locationWebsiteButton.titleLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetUrl]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView * scrollView = self.view;
    scrollView.frame = (CGRect){scrollView.frame.origin, CGSizeMake(320, 480)};
    scrollView.contentSize = CGSizeMake(320, 1000);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Church Details Information";
    self.navigationItem.titleView = label;
    
    NSError *jsonError;
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"ChurchDetails" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&jsonError];
    //    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHURCH_DETAILS_JSON] options:kNilOptions error:&jsonError];
    
    //    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *jsonFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ChurchDetails.json"];
    //    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath options:kNilOptions error:&jsonError];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    
    NSArray *jsonArray = [json objectForKey:@"placemark"];
    self.locationList = jsonArray;
    
    NSDictionary *locationItem = [locationList objectAtIndex:[self findRowNumberWithText:targetLocation]];
    
    locationName.text = [locationItem valueForKey:@"name"];
    locationName.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    locationName.lineBreakMode = UILineBreakModeWordWrap;
    locationName.numberOfLines = 0;
    CGRect labelFrame = locationName.frame;
    labelFrame.size.width = 280;
    locationName.frame = labelFrame;
    [locationName sizeToFit];
    
    locationAddressString.text = [locationItem valueForKey:@"address"];
    NSLog(@"locationAddressString: %@", locationAddressString.text);
    locationAddressString.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    locationAddressString.lineBreakMode = UILineBreakModeWordWrap;
    locationAddressString.numberOfLines = 0;
    labelFrame = locationAddressString.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = locationName.frame.size.height + locationName.frame.origin.y + 3.0f;
    locationAddressString.frame = labelFrame;
    [locationAddressString sizeToFit];
    
    locationDescription.text = [locationItem valueForKey:@"description"];
    NSLog(@"locationDescription: %@", locationDescription.text);
    locationDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    locationDescription.lineBreakMode = UILineBreakModeWordWrap;
    locationDescription.numberOfLines = 0;
    labelFrame = locationDescription.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = locationAddressString.frame.size.height + locationAddressString.frame.origin.y + 10.0f;
    locationDescription.frame = labelFrame;
    [locationDescription sizeToFit];
    
    locationContactHeader.text = @"For more information, please contact...";
    locationContactHeader.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    locationContactHeader.lineBreakMode = UILineBreakModeWordWrap;
    locationContactHeader.numberOfLines = 0;
    labelFrame = locationContactHeader.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = locationDescription.frame.size.height + locationDescription.frame.origin.y + 10.0f;
    locationContactHeader.frame = labelFrame;
    [locationContactHeader sizeToFit];
    
    locationContact.text = [locationItem valueForKey:@"contact"];
    NSLog(@"locationContact: %@", locationContact.text);
    locationContact.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    locationContact.lineBreakMode = UILineBreakModeWordWrap;
    locationContact.numberOfLines = 0;
    labelFrame = locationContact.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = locationContactHeader.frame.size.height + locationContactHeader.frame.origin.y + 10.0f;
    locationContact.frame = labelFrame;
    [locationContact sizeToFit];
    
    [locationWebsiteButton setTitle:[locationItem valueForKey:@"website"] forState:UIControlStateNormal];
    labelFrame = locationWebsiteButton.frame;
    labelFrame.size.width = 280;
    labelFrame.origin.y = locationContact.frame.origin.y + locationContact.frame.size.height + 10.0f;
    locationWebsiteButton.frame = labelFrame;
    [locationWebsiteButton sizeToFit];
    
    
    // --- reverse-geocoding address
    //    NSLog(@"Coordinates are: %@", [[locationItem objectForKey:@"point"] valueForKey:@"coordinates"]);
    //
    //    NSArray *coordsPair = [[[locationItem objectForKey:@"point"] valueForKey:@"coordinates"] componentsSeparatedByString:@","];
    //    NSString *_lat = [coordsPair objectAtIndex:0];
    //    NSString *_long = [coordsPair objectAtIndex:1];
    //
    //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_long doubleValue] longitude:[_lat doubleValue]];
    //    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    //        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
    //        if (error){
    //            NSLog(@"Geocode failed with error: %@", error);
    //            return;
    //        }
    //        if(placemarks && placemarks.count > 0)
    //        {
    //            CLPlacemark *topResult = [placemarks objectAtIndex:0];
    //
    //            NSMutableString *addressString = [NSMutableString string];
    //            if ([topResult subThoroughfare] != Nil) {
    //                [addressString appendFormat:@"%@, ", [topResult subThoroughfare]];
    //            }
    //            if ([topResult thoroughfare] != Nil) {
    //                [addressString appendFormat:@"%@, ", [topResult thoroughfare]];
    //            }
    //            if ([topResult locality] != Nil) {
    //                [addressString appendFormat:@"%@, ", [topResult locality]];
    //            }
    //            if ([topResult administrativeArea] != Nil) {
    //                [addressString appendFormat:@"%@ ", [topResult administrativeArea]];
    //            }
    //            locationAddress.text = [NSString stringWithString:addressString];
    //            locationAddress.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
    //            locationAddress.lineBreakMode = UILineBreakModeWordWrap;
    //            locationAddress.numberOfLines = 0;
    //            CGRect labelFrame = locationAddress.frame;
    //            labelFrame.size.width = 280;
    //            labelFrame.origin.y = locationDescription.frame.size.height + locationDescription.frame.origin.y + 10.0f;
    //            locationAddress.frame = labelFrame;
    //            [locationAddress sizeToFit];
    //        }
    //    }];
    
    //    [locationWebsiteButton setTitle:[locationItem valueForKey:@"website"] forState:UIControlStateNormal];
    //    labelFrame = locationWebsiteButton.frame;
    //    labelFrame.size.width = 280;
    //    labelFrame.origin.y = locationDescription.frame.origin.y + locationDescription.frame.size.height + 20.0f;
    //    if (locationAddress.text != nil) {
    //        labelFrame.origin.y = labelFrame.origin.y + locationAddress.frame.size.height + 20.0f;
    //    }
    //    locationWebsiteButton.frame = labelFrame;
    //    [locationWebsiteButton sizeToFit];
}

- (void)viewDidUnload
{
    [self setLocationAddressString:nil];
    [self setLocationContactHeader:nil];
    [self setLocationContact:nil];
    [self setLocationName:nil];
    [self setLocationAddressString:nil];
    [self setLocationDescription:nil];
    [self setLocationContactHeader:nil];
    [self setLocationContact:nil];
    [self setLocationWebsiteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
