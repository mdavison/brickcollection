//
//  SetDetailTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "SetDetailTableViewController.h"

@interface SetDetailTableViewController ()

//@property (nonatomic) NSMutableArray *selectedBricks;
//@property (nonatomic) Brick *selectedBrick;
//@property (nonatomic) UIBarButtonItem *missingButton;
//@property (nonatomic) UIBarButtonItem *foundButton;
@property (nonatomic) NSArray *orderedBricks;

@end


@implementation SetDetailTableViewController

- (void)viewDidLoad {
    self.title = @"Set Details";
    //self.tableView.allowsMultipleSelection = YES;
    
    
    [super viewDidLoad];
    
//    self.missingButton = [[UIBarButtonItem alloc] initWithTitle:@"Missing"
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(addToMissingBricks)];
//    
//    self.foundButton = [[UIBarButtonItem alloc] initWithTitle:@"Found"
//                                                                    style:UIBarButtonItemStylePlain
//                                                                   target:self
//                                                                   action:@selector(removeFromMissingBricks)];
//    
//    [self addToolbar];
    
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 2) {
//    }
//}

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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    InstructionsCollectionViewController *controller = (InstructionsCollectionViewController *)segue.destinationViewController;
    
    controller.managedObjectContext = self.managedObjectContext;
    controller.set = self.set;
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
        //UIImageView *checkmarkImageView = [cell viewWithTag:2005];
        UIImageView *missingImageView = [cell viewWithTag:2004];
        
        //Brick *brick = [self.set.bricks allObjects][indexPath.row];
        Brick *brick = self.orderedBricks[indexPath.row];
        
        brickImageView.image = [UIImage imageWithData:brick.brickImage];
        itemNumberLabel.text = brick.itemNumber;
        
        // Set the selected checkmark
//        if ([cell isSelected]) {
//            [checkmarkImageView setHidden:false];
//        } else {
//            [checkmarkImageView setHidden:true];
//        }
        
        // Set the missing icon
        if (brick.missing == true) {
            [missingImageView setHidden:false];
        } else {
            [missingImageView setHidden:true];
        }

    }
}

//- (void)addToolbar {
//    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                    target:self
//                                                                                    action:nil];
//    
//    [self setToolbarItems:[NSArray arrayWithObjects:self.missingButton, flexButton, self.foundButton, nil]];
//}

//- (void)addToMissingBricks {
//    // Add missing property to each brick
//    for (Brick *brick in self.selectedBricks) {
//        brick.missing = true;
//    }
//    
//    [self.selectedBricks removeAllObjects];
//    
//    // Hide the toolbar
//    [self.navigationController setToolbarHidden:YES animated:YES];
//    
//    [self.tableView reloadData];
//}
//
//- (void)removeFromMissingBricks {
//    for (Brick *brick in self.selectedBricks) {
//        brick.missing = false;
//    }
//    
//    [self.selectedBricks removeAllObjects];
//    
//    // Hide the toolbar
//    [self.navigationController setToolbarHidden:YES animated:YES];
//    
//    [self.tableView reloadData];
//}

//- (void)toggleToolbarButtons {
//    // Find out if the selected bricks all have the same "missing" property value or not
//    bool missing = false;
//    bool notMissing = false;
//    
//    for (Brick *brick in self.selectedBricks) {
//        if (brick.missing == true) {
//            missing = true;
//        } else {
//            notMissing = true;
//        }
//    }
//    
//    if (missing && notMissing) {
//        // We have a mixed batch and both buttons should be disabled
//        [self.missingButton setEnabled:false];
//        [self.foundButton setEnabled:false];
//    } else {
//        if (missing && !notMissing) { // All selected bricks are missing
//            [self.foundButton setEnabled:true];
//            [self.missingButton setEnabled:false];
//        }
//        
//        if (notMissing && !missing) { // No selected bricks are missing
//            [self.foundButton setEnabled:false];
//            [self.missingButton setEnabled:true];
//        }
//    }
//}

//- (void)toggleCheckmarkOn:(bool)on forIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    UIImageView *checkmarkImage = [cell viewWithTag:2005];
//    
//    if (on) {
//        // Find out if the cell is selected
//        if ([cell isSelected]) {
//            [checkmarkImage setHidden:false];
//        }
//    } else {
//        [checkmarkImage setHidden:true];
//    }
//}


@end
