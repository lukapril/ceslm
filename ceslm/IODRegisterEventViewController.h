//
//  IODRegisterEventViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-19.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface IODRegisterEventViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *eventNameString;

@property (weak, nonatomic) IBOutlet UILabel *registerEventName;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)sendRegistration:(id)sender;
- (IBAction)cancel:(id)sender;


@end
