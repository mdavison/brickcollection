//
//  MissingBricksTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/7/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "Brick.h"
#import "FindBrickResultsTableViewController.h"

@interface MissingBricksTableViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
