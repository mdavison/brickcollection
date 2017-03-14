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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
        return @"Missing Brick:";
    } else {
        return @"Found in Sets:";
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Helper methods

- (void)searchSets {
    if (!self.foundSets) {
        self.foundSets = [NSMutableArray array];
    }
    
    for (Set *set in self.dataModel.sets) {
        for (Brick *brick in set.bricks) {
            if ([self.missingBrick.itemNumber isEqualToString:brick.itemNumber]) {
                [self.foundSets addObject:set];
            }
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UILabel *brickLabel = [cell viewWithTag:5000];
        UIImageView *brickImageView = [cell viewWithTag:5001];
        
        brickLabel.text = [@"Item No: " stringByAppendingString:self.missingBrick.itemNumber];
        brickImageView.image = self.missingBrick.brickImage;
    } else {
        Set *set = self.foundSets[indexPath.row];
        
        UILabel *setLabel = [cell viewWithTag:6000];
        UIImageView *setImageView = [cell viewWithTag:6001];
        
        setLabel.text = set.productName;
        setImageView.image = set.productImage;
    }
}

@end
