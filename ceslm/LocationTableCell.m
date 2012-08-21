//
//  LocationTableCell.m
//  ceslm
//
//  Created by April Luk on 12-06-20.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import "LocationTableCell.h"

@implementation LocationTableCell

@synthesize locationName = _locationName;
@synthesize locationDescription = _locationDescription;
@synthesize locationWebsiteButton = _locationWebsiteButton;
@synthesize locationAddress = _locationAddress;

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

- (IBAction)goToUrl:(id)sender {
    NSString* targetUrl = _locationWebsiteButton.titleLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetUrl]];
}
@end
