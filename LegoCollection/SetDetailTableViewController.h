//
//  SetDetailTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "Brick.h"
#import "InstructionsCollectionViewController.h"
#import "BrickResultsTableViewController.h"

@interface SetDetailTableViewController : UITableViewController

@property (nonatomic) Set *set;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
