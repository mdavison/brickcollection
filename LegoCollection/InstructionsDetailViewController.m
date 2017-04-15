//
//  InstructionsDetailViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 4/11/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "InstructionsDetailViewController.h"

@interface InstructionsDetailViewController ()

@end

@implementation InstructionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    NSURL *pdfURL = [NSURL URLWithString:self.pdfURLString];
    NSURLRequest *pdfRequest = [NSURLRequest requestWithURL:pdfURL];
    [self.webView loadRequest:pdfRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Add network request indicator to status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Remove the network activity indicator from the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Stop the activity indicator
    [self.activityIndicator stopAnimating];
}

@end
