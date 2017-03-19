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
    self.searchTextField.delegate = self;
    self.brickSearchTextField.delegate = self;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    self.error = nil;
    
    [super viewDidAppear:animated];
    
    if (![self.brickSearchTextField.text isEqualToString:@""]) {
        [self.brickSearchTextField becomeFirstResponder];
    } else {
        [self.searchTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchActivityIndicator stopAnimating];
    [self.searchButton setHidden:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NULL;
}


#pragma mark - ResultsTableViewControllerDelegate methods

- (void)resultsTableViewControllerDidCancel:(ResultsTableViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

-(void)resultsTableViewController:(ResultsTableViewController *)controller didFinishAddingSet:(Set *)set {
    [self.dataModel.sets addObject:set];
    
    [controller dismissViewControllerAnimated:true completion:nil];
    
    // Notify user that set has been added
    NSString *message = [NSString stringWithFormat:@"The %@ set has been added to your collection.", set.productName];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Added!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - TextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.searchTextField]) {
        NSString *oldText = self.searchTextField.text;
        NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
        
        [self.searchButton setEnabled:newText.length > 0];
    } else {
        NSString *oldText = self.brickSearchTextField.text;
        NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
        
        [self.brickSearchButton setEnabled:newText.length > 0];
    }
    
    return true;
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ResultsSegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ResultsTableViewController *controller = (ResultsTableViewController *)navController.topViewController;
        
        controller.delegate = self;
        controller.dataModel = self.dataModel;
        controller.jsonData = sender;
        if (self.error) {
            controller.error = self.error;
        }
    } else if ([segue.identifier isEqualToString:@"BrickResultsSegue"]) {
        
        BrickResultsTableViewController *controller = (BrickResultsTableViewController *)segue.destinationViewController;
        
        controller.foundBricks = sender;
    }
}



#pragma mark - Actions

- (IBAction)search:(UIButton *)sender {
    self.brickSearchTextField.text = @"";
    [self.brickSearchButton setEnabled:false];
    
    [self.searchButton setHidden:true];
    [self.searchActivityIndicator setHidden:false];
    [self.searchActivityIndicator startAnimating];
    
    [self performSearchRequest];
}

- (IBAction)brickSearch:(UIButton *)sender {
    self.searchTextField.text = @"";
    [self.searchButton setEnabled:false];
    
    NSMutableArray *foundBricks = [NSMutableArray array];
    for (Set *set in self.dataModel.sets) {
        for (Brick *brick in set.bricks) {
            if ([brick.itemNumber isEqualToString:self.brickSearchTextField.text]) {
                [foundBricks addObject:brick];
            }
        }
    }
    
    [self performSegueWithIdentifier:@"BrickResultsSegue" sender:foundBricks];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.searchTextField resignFirstResponder];
    [self.brickSearchTextField resignFirstResponder];
}

// TODO: move this to DataModel?
- (void)performSearchRequest {
    // Add network request indicator to status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error != NULL) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            
            // When json is loaded, perform segue with data
            if (error) {
                self.error = error;
            }
            
            [self performSegueWithIdentifier:@"ResultsSegue" sender:jsonData];
        });

    }] resume];
}


@end
