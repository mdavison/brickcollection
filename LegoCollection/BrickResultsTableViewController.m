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
