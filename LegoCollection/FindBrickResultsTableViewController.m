//
//  FindBrickResultsTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/13/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "FindBrickResultsTableViewController.h"

@interface FindBrickResultsTableViewController ()

@property (nonatomic) NSMutableArray *foundSets;

@end

@implementation FindBrickResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sets";
    
    [self searchSets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.foundSets count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrickCell"
                                                                forIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"
                                               forIndexPath:indexPath];
    }

    [self configureCell: cell forIndexPath: indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 142.0;
    } else {
        return 86.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [@"Item Number: " stringByAppendingString:self.missingBrick.itemNumber];
    } else {
        return @"In Sets:";
    }
}


#pragma mark - Helper methods

- (void)searchSets {
    if (!self.foundSets) {
        self.foundSets = [NSMutableArray array];
    }
    
    NSArray *allSets = [Set getAllWithManagedObjectContext:self.managedObjectContext];
    for (Set *set in allSets) {
        for (Brick *brick in set.bricks) {
            if ([self.missingBrick.itemNumber isEqualToString:brick.itemNumber]) {
                [self.foundSets addObject:set];
            }
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIImageView *brickImageView = [cell viewWithTag:5000];
        
        brickImageView.image = [UIImage imageWithData:self.missingBrick.brickImage];
    } else {
        Set *set = self.foundSets[indexPath.row];
        
        UILabel *setLabel = [cell viewWithTag:6000];
        UIImageView *setImageView = [cell viewWithTag:6001];
        
        setLabel.text = set.productName;
        setImageView.image = [UIImage imageWithData:set.productImage];
    }
}


@end
