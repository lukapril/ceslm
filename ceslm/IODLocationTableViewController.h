//
//  IODLocationTableViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-14.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IODLocationTableViewController : UITableViewController {
    NSArray *locationList;
    NSString *targetLocation;
    IBOutlet UITableView *locationTableView;
}

@property (nonatomic, retain) NSArray *locationList;
@property (nonatomic, retain) NSString *targetLocation;

- (void) buildLocationList;
- (NSInteger) findRowNumberWithText: (NSString *)text;


@end
