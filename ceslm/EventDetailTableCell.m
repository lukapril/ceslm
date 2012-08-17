//
//  EventDetailTableCell.m
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "EventDetailTableCell.h"

@implementation EventDetailTableCell

@synthesize eventName = _eventName;
@synthesize eventDate = _eventDate;
@synthesize eventLocation = _eventLocation;
@synthesize eventContactHeader = _eventContactHeader;
@synthesize eventContactText = _eventContactText;
@synthesize eventDescription = _eventDescription;
@synthesize setEventReminderButton;
@synthesize registerEventButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
