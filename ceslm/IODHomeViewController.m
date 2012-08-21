//
//  IODHomeViewController.m
//  ceslm
//
//  Created by April Luk on 12-07-03.
//  Copyright (c) 2012 April Luk All rights reserved.
//

#import "IODHomeViewController.h"

@interface IODHomeViewController ()

@end

@implementation IODHomeViewController

@synthesize webview;

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
    self.webview.opaque = NO;
    self.webview.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    label.backgroundColor = [UIColor clearColor];
    label.font =     [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"What's New";
    self.navigationItem.titleView = label;
    
    NSURLRequest *request;
    
    if (ENV == @"PROD") {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"AboutUs.html"];
        request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutUs" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        request = [NSURLRequest requestWithURL:url];
    }
    
    [webview loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
