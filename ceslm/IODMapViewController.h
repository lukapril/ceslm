//
//  IODMapViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-07.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "KMLParser.h"

@interface IODMapViewController : UIViewController {
    KMLParser *kmlParser;
}

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nearby_navButton;

- (IBAction)navTo_nearby:(id)sender;

@end
