//
//  IODNewsletterViewController.m
//  ceslm
//
//  Created by April Luk on 12-06-18.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import "IODNewsletterViewController.h"

@interface IODNewsletterViewController ()

@end

@implementation IODNewsletterViewController
@synthesize userTextField;
@synthesize emailTextField;
@synthesize subscribeButton;

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
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Signup for Newsletter";
    self.navigationItem.titleView = label;

}

- (void)viewDidUnload
{
    [self setUserTextField:nil];
    [self setEmailTextField:nil];
    [self setSubscribeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendSubscription:(id)sender {
    if ([self.userTextField.text isEmpty] || [self.emailTextField.text isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Both Name and Email Address are required in order to subscribe to Newsletter. Please try again." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
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
            [mfViewController setToRecipients:[NSArray arrayWithObject:SUBSCRIPTION_EMAIL]];
            [mfViewController setSubject:@"Newsletter Subscription Request"];
            NSString *emailBody = [NSString stringWithFormat:@"I would like to subscribe to the CESLM monthly newsletter. \n\n Participants Information:\n %@\n %@", userTextField.text, emailTextField.text];
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
            alert = [[UIAlertView alloc] initWithTitle:@"Subscription Request Sent" message:@"Your newsletter subscription request is sent successfully." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [self dismissModalViewControllerAnimated:NO];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send subscription request email. There may be some network error. Please try again later" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Cancelled" message:@"Email was cancelled. No subscription request email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Email Saved" message:@"Email was saved as draft. No subscription request email is being sent." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
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
