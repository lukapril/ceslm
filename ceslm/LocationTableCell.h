//
//  LocationTableCell.h
//  ceslm
//
//  Created by April Luk on 12-06-20.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *locationName;
@property (nonatomic, strong) IBOutlet UILabel *locationDescription;
@property (nonatomic, strong) IBOutlet UIButton *locationWebsiteButton;
@property (nonatomic, strong) IBOutlet UILabel *locationAddress;

- (IBAction)goToUrl:(id)sender;

@end
