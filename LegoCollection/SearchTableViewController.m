//
//  SearchTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/25/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "SearchTableViewController.h"

@interface SearchTableViewController ()

@property NSError *error;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    self.error = nil;
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



#pragma mark - ResultsTableViewControllerDelegate methods

- (void)resultsTableViewControllerDidCancel:(ResultsTableViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

-(void)resultsTableViewController:(ResultsTableViewController *)controller didFinishAddingSet:(Set *)set {
    NSLog(@"set to add: %@", set.productName);
    [self.dataModel.sets addObject:set];
    
    [controller dismissViewControllerAnimated:true completion:nil];
    NSLog(@"set added");
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ResultsSegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ResultsTableViewController *controller = (ResultsTableViewController *)navController.topViewController;
        
        controller.delegate = self;
        controller.jsonData = sender;
        if (self.error) {
            controller.error = self.error;
        }
    }
}



#pragma mark - Actions

- (IBAction)search:(UIButton *)sender {
    [self performSearchRequest];
}

- (void)performSearchRequest {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];

    NSString *urlString = [[@"https://www.lego.com/en-US/service/rpservice/getproduct?productnumber=" stringByAppendingString:self.searchTextField.text] stringByAppendingString:@"&isSalesFlow=true"];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSString *cookie = @"csAgeAndCountry={\"age\":\"18\",\"countrycode\":\"US\"}";
    [request addValue:cookie forHTTPHeaderField: @"cookie"];
    [request addValue:@"en-US" forHTTPHeaderField:@"PROMARKETPREF"];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonData;
        
        if (data) {
            jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        
        if (error != NULL) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // When json is loaded, perform segue with data
            if (error) {
                self.error = error;
            }
            [self performSegueWithIdentifier:@"ResultsSegue" sender:jsonData];
        });

    }] resume];
    
    // TODO: add loading icon
}


@end
