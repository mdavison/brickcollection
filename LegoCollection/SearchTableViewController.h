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

@interface SearchTableViewController : UITableViewController <ResultsTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic) DataModel *dataModel;

- (IBAction)search:(UIButton *)sender;

@end
