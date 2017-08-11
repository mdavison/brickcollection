//
//  BrickResultsTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/9/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "BrickResultsTableViewController.h"

@interface BrickResultsTableViewController ()

@end

@implementation BrickResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.foundBricks count] == 0) {
        return 1;
    } else {
        return [self.foundBricks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrickResultCell" forIndexPath:indexPath];
    
    if ([self.foundBricks count] == 0) {
        [self configureCell:cell withBrick:NULL];
    } else {
        // Get the brick
        Brick *brick = self.foundBricks[indexPath.row];
        
        [self configureCell:cell withBrick:brick];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the selected cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Get the brick
    //Brick *brick = self.orderedBricks[indexPath.row];
    Brick *brick = self.foundBricks[indexPath.row];
    
    // Get the missing brick icon view
    UIImageView *missingImageView = [cell viewWithTag:4003];
    
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


#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withBrick:(Brick *)brick {
    UIImageView *brickImageView = [cell viewWithTag:4000];
    UILabel *brickLabel = [cell viewWithTag:4001];
    UILabel *setLabel = [cell viewWithTag:4002];
    UIImageView *missingImageView = [cell viewWithTag:4003];
    
    
    if (brick == NULL) {
        brickLabel.text = [NSString localizedStringWithFormat:@"No bricks were found."];
        setLabel.text = @"";
    } else {
        brickImageView.image = [UIImage imageWithData:brick.brickImage];
        brickLabel.text = [[NSString localizedStringWithFormat:@"Item No: "] stringByAppendingString:brick.itemNumber];
        setLabel.text = [[NSString localizedStringWithFormat:@"Set: "] stringByAppendingString:brick.set.productName];
        
        // Set the missing icon
        if (brick.missing == true) {
            [missingImageView setHidden:false];
        } else {
            [missingImageView setHidden:true];
        }
    }
}

@end
