//
//  ResultsTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 2/26/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "Brick.h"

@class ResultsTableViewController;
@protocol ResultsTableViewControllerDelegate <NSObject>

- (void)resultsTableViewControllerDidCancel:(ResultsTableViewController *)controller;
- (void)resultsTableViewController:(ResultsTableViewController *)controller didFinishAddingSet:(Set *)set;

@end

@interface ResultsTableViewController : UITableViewController

@property (nonatomic) id <ResultsTableViewControllerDelegate> delegate;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSDictionary *jsonData;
@property (nonatomic) NSError *error;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)addToSets:(UIBarButtonItem *)sender;


@end
