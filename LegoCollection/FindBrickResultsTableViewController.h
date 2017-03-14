//
//  FindBrickResultsTableViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/13/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "Brick.h"

@interface FindBrickResultsTableViewController : UITableViewController

@property (nonatomic) DataModel *dataModel;
@property (nonatomic) Brick *missingBrick;

@end
