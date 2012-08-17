//
//  IODLocationDetailsScrollViewController.h
//  ceslm
//
//  Created by April Luk on 12-08-16.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IODLocationDetailsScrollViewController : UIViewController {
    NSArray *locationList;
    NSString *targetLocation;
}

@property (nonatomic, retain) NSArray *locationList;
@property (nonatomic, retain) NSString *targetLocation;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressString;
@property (weak, nonatomic) IBOutlet UILabel *locationDescription;
@property (weak, nonatomic) IBOutlet UILabel *locationContactHeader;
@property (weak, nonatomic) IBOutlet UITextView *locationContactText;


- (NSInteger) findRowNumberWithText: (NSString *)text;

@end
