//
//  SearchTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 2/25/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "ResultsTableViewController.h"
#import "BrickResultsTableViewController.h"
#import "Brick.h"

@interface SearchTableViewController : UITableViewController <ResultsTableViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;

@property (weak, nonatomic) IBOutlet UITextField *brickSearchTextField;
@property (weak, nonatomic) IBOutlet UIButton *brickSearchButton;


@property (nonatomic) DataModel *dataModel;

- (IBAction)search:(UIButton *)sender;
- (IBAction)brickSearch:(UIButton *)sender;
- (IBAction)tap:(UITapGestureRecognizer *)sender;

@end
