//
//  IODRegisterEventViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-19.
//  Copyright (c) 2012 Assn Dot Ca Inc. All rights reserved.
//

#import "IODRegisterEventViewController.h"
#import "IODUpcomingEventTableViewController.h"
#import "EventDetailTableCell.h"

@interface IODRegisterEventViewController ()

@end

@implementation IODRegisterEventViewController

@synthesize eventNameString;

@synthesize registerEventName;
@synthesize userTextField;
@synthesize emailTextField;
@synthesize registerButton;

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
    label.text = @"Event Registration";
    self.navigationItem.titleView = label;

    self.registerEventName.lineBreakMode = UILineBreakModeWordWrap;
    self.registerEventName.numberOfLines = 0;
    self.registerEventName.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    self.registerEventName.text = eventNameString;
}

- (void)viewDidUnload
{
    [self setRegisterEventName:nil];
    [self setUserTextField:nil];
    [self setEmailTextField:nil];
    [self setRegisterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendRegistration:(id)sender { 
    if ([self.userTextField.text isEmpty] || [self.emailTextField.text isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Both Name and Email Address are required in order to register for an event. Please try again." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (![self.emailTextField.text isValidEmail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"Please enter a valid Email Address and try again." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        return;
    } 
    else {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
            mfViewController.mailComposeDelegate = self;
            [mfViewController setToRecipients:[NSArray arrayWithObject:REGISTRATION_EMAIL]];
            [mfViewController setSubject:[NSString stringWithFormat:@"Registration request for Event: %@.", registerEventName.text]];
            NSString *emailBody = [NSString stringWithFormat:@"Please register me for Event:\n %@\n\n Participants Information:\n %@\n %@", registerEventName.text, userTextField.text, emailTextField.text];
            [mfViewController setMessageBody:emailBody isHTML:NO];
            [self presentModalViewController:mfViewController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please make sure your device is configured to send email, and try again." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller 
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alert = [UIAlertView alloc];

    switch (result) {
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Your registration is sent successfully." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [self dismissModalViewControllerAnimated:NO];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send registration email. There may be some network error. Please try again later " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Cancelled" message:@"Email was cancelled. No Registration email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Saved" message:@"Email was saved as draft. No Registration email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        default:
            break;
    }
    [alert show];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    
    if (textField == self.emailTextField) {        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

@end
