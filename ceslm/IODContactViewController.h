//
//  IODContactViewController.h
//  ceslm
//
//  Created by April Luk on 12-06-07.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface IODContactViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *newsLetterButton;


- (IBAction)emailFeedback:(id)sender;
- (IBAction)goToUrl:(id)sender;
- (IBAction)goToFbUrl:(id)sender;
- (IBAction)registerNewsLetter:(id)sender;

@end
