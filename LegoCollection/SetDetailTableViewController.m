//
//  SetDetailTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "SetDetailTableViewController.h"

@interface SetDetailTableViewController ()

@property (nonatomic) NSMutableArray *selectedBricks;
@property (nonatomic) UIBarButtonItem *missingButton;
@property (nonatomic) UIBarButtonItem *foundButton;
@property (nonatomic) NSArray *orderedBricks;

@end


@implementation SetDetailTableViewController

- (void)viewDidLoad {
    self.title = @"Set Details";
    self.tableView.allowsMultipleSelection = YES;
    
    [super viewDidLoad];
    
    self.missingButton = [[UIBarButtonItem alloc] initWithTitle:@"Missing"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addToMissingBricks)];
    
    self.foundButton = [[UIBarButtonItem alloc] initWithTitle:@"Found"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(removeFromMissingBricks)];
    
    [self addToolbar];
    
    // Sort the bricks
    NSSortDescriptor *missingBrickSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"missing" ascending:NO];
    NSSortDescriptor *brickSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemNumber" ascending:YES];
    self.orderedBricks = [[NSArray alloc] initWithArray:[self.set.bricks sortedArrayUsingDescriptors:@[missingBrickSortDescriptor, brickSortDescriptor]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Hide the toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
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
    if (section == 0) {
        return 1;
    } else {
        return [self.orderedBricks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([indexPath section] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrickCell" forIndexPath:indexPath];
    }
    
    [self configureCell:cell withSection:indexPath.section indexPath:indexPath];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    } else {
        return NULL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 177.0;
    } else {
        return 112.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Show the checkmark
    [self toggleCheckmarkOn:true forIndexPath:indexPath];
    
    // Show the toolbar
    if ([self.navigationController.toolbar isHidden]) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    // Initialize the array if it hasn't been initialized yet
    if (!self.selectedBricks) {
        self.selectedBricks = [NSMutableArray array];
    }
    
    // Add to selected sets array
    Brick *selectedBrick = [self.set.bricks allObjects][indexPath.row];
    [self.selectedBricks addObject:selectedBrick];
    
    [self toggleToolbarButtons];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide the checkmark
    [self toggleCheckmarkOn:false forIndexPath:indexPath];
    
    Brick *selectedBrick = [self.set.bricks allObjects][indexPath.row];
    [self.selectedBricks removeObject:selectedBrick];
    
    // If no more rows are selected, hide the toolbar
    if ([[self.tableView indexPathsForSelectedRows] count] < 1) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    
    [self toggleToolbarButtons];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString *title = self.set.productName;
        if (self.set.productNumber) {
            title = [[title stringByAppendingString:@": "] stringByAppendingString:self.set.productNumber];
        }
        
        return title;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withSection:(NSInteger)section indexPath:(NSIndexPath *)indexPath {
    if (section == 0) {
        UIImageView *productImageView = [cell viewWithTag:2000];
        productImageView.image = [UIImage imageWithData:self.set.productImage];
    } else {
        // Get the views
        UIImageView *brickImageView = [cell viewWithTag:2002];
        UILabel *itemNumberLabel = [cell viewWithTag:2003];
        UIImageView *checkmarkImageView = [cell viewWithTag:2005];
        UIImageView *missingImageView = [cell viewWithTag:2004];
        
        //Brick *brick = [self.set.bricks allObjects][indexPath.row];
        Brick *brick = self.orderedBricks[indexPath.row];
        
        brickImageView.image = [UIImage imageWithData:brick.brickImage];
        itemNumberLabel.text = brick.itemNumber;
        
        // Set the selected checkmark
        if ([cell isSelected]) {
            [checkmarkImageView setHidden:false];
        } else {
            [checkmarkImageView setHidden:true];
        }
        
        // Set the missing icon
        if (brick.missing == true) {
            [missingImageView setHidden:false];
        } else {
            [missingImageView setHidden:true];
        }

    }
}

- (void)addToolbar {
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:self.missingButton, flexButton, self.foundButton, nil]];
}

- (void)addToMissingBricks {
    // Add missing property to each brick
    for (Brick *brick in self.selectedBricks) {
        brick.missing = true;
    }
    
    [self.selectedBricks removeAllObjects];
    
    // Hide the toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.tableView reloadData];
}

- (void)removeFromMissingBricks {
    for (Brick *brick in self.selectedBricks) {
        brick.missing = false;
    }
    
    [self.selectedBricks removeAllObjects];
    
    // Hide the toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.tableView reloadData];
}

- (void)toggleToolbarButtons {
    // Find out if the selected bricks all have the same "missing" property value or not
    bool missing = false;
    bool notMissing = false;
    
    for (Brick *brick in self.selectedBricks) {
        if (brick.missing == true) {
            missing = true;
        } else {
            notMissing = true;
        }
    }
    
    if (missing && notMissing) {
        // We have a mixed batch and both buttons should be disabled
        [self.missingButton setEnabled:false];
        [self.foundButton setEnabled:false];
    } else {
        if (missing && !notMissing) { // All selected bricks are missing
            [self.foundButton setEnabled:true];
            [self.missingButton setEnabled:false];
        }
        
        if (notMissing && !missing) { // No selected bricks are missing
            [self.foundButton setEnabled:false];
            [self.missingButton setEnabled:true];
        }
    }
}

- (void)toggleCheckmarkOn:(bool)on forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkmarkImage = [cell viewWithTag:2005];
    
    if (on) {
        // Find out if the cell is selected
        if ([cell isSelected]) {
            [checkmarkImage setHidden:false];
        }
    } else {
        [checkmarkImage setHidden:true];
    }
}


@end
