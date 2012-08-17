//
//  EventDetailTableCell.h
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventDate;
@property (nonatomic, strong) IBOutlet UILabel *eventLocation;
@property (nonatomic, strong) IBOutlet UILabel *eventContactHeader;
@property (weak, nonatomic) IBOutlet UITextView *eventContactText;
@property (nonatomic, strong) IBOutlet UILabel *eventDescription;
@property (nonatomic, strong) IBOutlet UIButton *setEventReminderButton;
@property (nonatomic, strong) IBOutlet UIButton *registerEventButton;


@end
