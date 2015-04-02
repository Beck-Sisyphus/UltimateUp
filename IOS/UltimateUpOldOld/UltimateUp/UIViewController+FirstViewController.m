//
//  UIViewController+FirstViewController.m
//  UltimateUp
//
//  Created by Beck Pang on 2/22/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//
#import "UIViewController+FirstViewController.h"
#import <Relayr/Relayr.h>

@implementation UIViewController (FirstViewController)
// OAuth for Wunderbar for Hackster in Seattle, Feb.21st, 2015
#define RelayrAppID = "fee853e1-dc92-4a4c-8602-b4c29060b5dc"
#define RelayrAppSecret = "NH4AQo_d4EasxF-iMTeImSs3lAha-QsJ"
#define RelayrRedirectURI = "http://localhost"

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrRedirectURI completion:^(NSError* error, RelayrApp* app) {
    if (error) { return; }
    [app signInUser:^(NSError* error, RelayrUser* user) {
        if (error) { return; }
        
        NSLog(@"User correctly signed!");
    }];
    }];
}
@end
