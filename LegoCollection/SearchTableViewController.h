//
//  SearchTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 2/25/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"

@interface SearchTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


- (IBAction)search:(UIButton *)sender;

@end
