//
//  SetDetailTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "SetDetailTableViewController.h"

@interface SetDetailTableViewController ()

@property (nonatomic) NSArray *orderedBricks;

@end


@implementation SetDetailTableViewController

- (void)viewDidLoad {
    self.title = @"Set Details";
    
    [super viewDidLoad];
    
    // Sort the bricks
    NSSortDescriptor *missingBrickSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"missing" ascending:NO];
    NSSortDescriptor *brickSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemNumber" ascending:YES];
    self.orderedBricks = [[NSArray alloc] initWithArray:[self.set.bricks sortedArrayUsingDescriptors:@[missingBrickSortDescriptor, brickSortDescriptor]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove the checkmarks and hide the toolbar
    [self.tableView reloadData];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? [self.orderedBricks count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"InstructionsCell" forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"BrickCell" forIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    [self configureCell:cell withSection:indexPath.section indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 177.0;
        case 1:
            return 66.0;
        default:
            return 112.0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Enable the "Missing" button on only the bricks section
    return indexPath.section == 2;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the selected cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Get the brick
    Brick *brick = self.orderedBricks[indexPath.row];
    
    // Get the missing brick icon view
    UIImageView *missingImageView = [cell viewWithTag:2004];
    
    NSString *buttonTitle = brick.missing ? NSLocalizedString(@"Mark\nFound", @"Mark as found") : NSLocalizedString(@"Mark\nMissing", @"Mark as missing");
    UIColor *missingColor = [UIColor colorWithRed:208.0/255.0 green:16.0/255.0 blue:4.0/255.0 alpha:1.0];
    UIColor *foundColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:64.0/255.0 alpha:1.0];
    UIColor *buttonBackgroundColor = brick.missing ? foundColor : missingColor;
    
    // Create custom button
    UITableViewRowAction *button = [UITableViewRowAction
                                    rowActionWithStyle:UITableViewRowActionStyleDefault
                                    title:buttonTitle
                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                        // Toggle the brick's missing status
                                        brick.missing = !brick.missing;
                                        
                                        // Show or hide the "missing" icon
                                        [missingImageView setHidden:!brick.missing];
                                        
                                        // End the editing
                                        [self.tableView setEditing:NO];
                                    }];
    
    button.backgroundColor = buttonBackgroundColor;
    
    return [[NSArray alloc] initWithObjects:button, nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *title = self.set.productName;
        if (self.set.productNumber) {
            title = [[title stringByAppendingString:@": "] stringByAppendingString:self.set.productNumber];
        }
        
        return title;
    } else if (section == 2) {
        NSString *title = NSLocalizedString(@"Swipe to mark missing", nil);
        
        return title;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped row");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FindBrickInOtherSetSegue"]) {
        BrickResultsTableViewController *controller = (BrickResultsTableViewController *)segue.destinationViewController;
        
        // todo: do brick search like in SearchTableViewController.m
        // get the brick user tapped on
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSMutableArray *foundBricks = [NSMutableArray array];
        Brick *selectedBrick = self.orderedBricks[indexPath.row];
        
        NSArray *allSets = [Set getAllWithManagedObjectContext:self.managedObjectContext];
        for (Set *set in allSets) {
            for (Brick *brick in set.bricks) {
                if ([brick.itemNumber isEqualToString:selectedBrick.itemNumber]) {
                    [foundBricks addObject:brick];
                }
            }
        }
        
        controller.foundBricks = foundBricks;
    } else {
        InstructionsCollectionViewController *controller = (InstructionsCollectionViewController *)segue.destinationViewController;
        
        controller.managedObjectContext = self.managedObjectContext;
        controller.set = self.set;
    }
}


#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withSection:(NSInteger)section indexPath:(NSIndexPath *)indexPath {

    if (section == 0) {
        UIImageView *productImageView = [cell viewWithTag:2000];
        if (self.set.productImage) {
            productImageView.image = [UIImage imageWithData:self.set.productImage];
        } else {
            productImageView.image = [UIImage imageNamed:@"SetDetailImageUnavailable"];
        }
    } else if (section == 1) {
        // Instructions cell
    } else {
        // Get the views
        UIImageView *brickImageView = [cell viewWithTag:2002];
        UILabel *itemNumberLabel = [cell viewWithTag:2003];
        UIImageView *missingImageView = [cell viewWithTag:2004];
        
        Brick *brick = self.orderedBricks[indexPath.row];
        
        brickImageView.image = [UIImage imageWithData:brick.brickImage];
        itemNumberLabel.text = brick.itemNumber;
        
        // Set the missing icon
        if (brick.missing == true) {
            [missingImageView setHidden:false];
        } else {
            [missingImageView setHidden:true];
        }

    }
}

@end
