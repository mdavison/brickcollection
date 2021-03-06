//
//  SetTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 2/28/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"
#import "Set.h"
#import "SetDetailTableViewController.h"

@interface SetTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
