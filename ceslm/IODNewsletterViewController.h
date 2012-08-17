//
//  IODNewsletterViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface IODNewsletterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

- (IBAction)sendSubscription:(id)sender;
- (IBAction)cancel:(id)sender;
@end
