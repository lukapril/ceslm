//
//  IODEventTableViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-14.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IODEventTableViewController : UITableViewController {
    NSString *selectedEvent;
    IBOutlet UITableView *eventTableView;
}

@property (nonatomic, retain) NSString *selectedEvent;
@property (nonatomic, strong) NSMutableArray *eventList;

- (void) buildEventList;

@end
