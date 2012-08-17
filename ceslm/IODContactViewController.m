//
//  IODContactViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-07.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODContactViewController.h"

@interface IODContactViewController ()

@end

@implementation IODContactViewController
@synthesize emailButton;
@synthesize contactLabel;
@synthesize urlButton;
@synthesize fbButton;
@synthesize newsLetterButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Contact Us";
    self.navigationItem.titleView = label;

    contactLabel.lineBreakMode = UILineBreakModeWordWrap;
    contactLabel.numberOfLines = 0;
    contactLabel.text = CONTACT_ADDRESS;
    contactLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
        
    [emailButton setTitle:FEEDBACK_EMAIL forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
    [urlButton setTitle:WEBSITE_URL forState:UIControlStateNormal];
    urlButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
    [fbButton setTitle:@"CESLM@Facebook" forState:UIControlStateNormal];
    fbButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
    [newsLetterButton setTitle:@"Sign-up for monthly newsletter" forState:UIControlStateNormal];
    newsLetterButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];

}

- (void)viewDidUnload
{
    [self setEmailButton:nil];
    [self setContactLabel:nil];
    [self setUrlButton:nil];
    [self setFbButton:nil];
    [self setNewsLetterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    UIAlertView *alert = [UIAlertView alloc];

    switch (result) {
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Thank you for your feedback! We will get back to you as soon as possible if you have any questions." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send feedback email. There may be some network error. Please try again later " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Cancelled" message:@"Email was cancelled. No feedback email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Saved" message:@"Email was saved as draft. No feedback email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        default:
            break;
    }
    [alert show];
	[self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)emailFeedback:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setToRecipients:[NSArray arrayWithObject:FEEDBACK_EMAIL]];
        [mfViewController setSubject:@"Question about CESLM"];
        
        [self presentModalViewController:mfViewController animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)goToUrl:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEBSITE_URL]];
}

- (IBAction)goToFbUrl:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FB_URL]];
}

- (IBAction)registerNewsLetter:(id)sender {
}


@end
