//
//  FindBrickResultsTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/13/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brick.h"
#import "Set+CoreDataProperties.h"

@interface FindBrickResultsTableViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Brick *missingBrick;

@end
