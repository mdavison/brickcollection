//
//  InfoTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/15/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




#pragma mark - Actions

- (IBAction)openLink:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (IBAction)rate:(UIButton *)sender {
    [SKStoreReviewController requestReview];
}

@end
