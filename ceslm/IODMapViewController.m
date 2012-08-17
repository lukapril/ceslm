//
//  IODMapViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-07.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODMapViewController.h"
#import "IODLocationTableViewController.h"
#import "IODLocationDetailsScrollViewController.h"

@interface IODMapViewController ()

@end

@implementation IODMapViewController
@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Calgary Church ESL Programs";
    self.navigationItem.titleView = label;

    // Locate the path to the route.kml file in the application's bundle
    // and parse it with the KMLParser.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ChurchESLCalgary" ofType:@"kml"];
    NSURL *url = [NSURL fileURLWithPath:path];
        
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ChurchESLCalgary.kml"];
//    NSURL *url = [NSURL fileURLWithPath:path];

    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    NSArray *overlays = [kmlParser overlays];
    [map addOverlays:overlays];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kmlParser points];
    [map addAnnotations:annotations];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    map.visibleMapRect = flyTo;
	
}

- (void)viewDidUnload
{
    [self setMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    return [kmlParser viewForOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [kmlParser viewForAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control 
{
    [view removeFromSuperview];
//    [self performSegueWithIdentifier:@"showLocations" sender:self];
    [self performSegueWithIdentifier:@"showLocationDetailsScroll" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showLocationDetailsScroll"]) {
        IODLocationDetailsScrollViewController *targetViewController = [segue destinationViewController];
        
        // Get the selected Pin location
        NSString *selectedLocation = [[map.selectedAnnotations objectAtIndex:0] title];
        NSLog(@"%@", selectedLocation);
        
        targetViewController.targetLocation = selectedLocation;
    }
    else if ([[segue identifier] isEqualToString:@"showLocations"]) {
        
        // Get destination view
        IODLocationTableViewController *targetViewController = [segue destinationViewController];
        
        // Get the selected Pin location
        NSString *selectedLocation = [[map.selectedAnnotations objectAtIndex:0] title];
        NSLog(@"%@", selectedLocation);
        
        // Pass the information to the destination view
        targetViewController.targetLocation = selectedLocation;
    }
}


@end
