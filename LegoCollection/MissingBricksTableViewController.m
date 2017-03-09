//
//  MissingBricksTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/7/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "MissingBricksTableViewController.h"

@interface MissingBricksTableViewController ()

@property (nonatomic) NSMutableArray *missingBricks;

@end


@implementation MissingBricksTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadMissingBricks];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.missingBricks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissingBrickCell" forIndexPath:indexPath];
    
    Brick *missingBrick = self.missingBricks[indexPath.row];
    
    [self configureCell:cell withBrick:missingBrick];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Brick *brick = self.missingBricks[indexPath.row];
        // Set the missing property of the brick to false
        brick.missing = false;
        
        // Remove from data model
        [self.missingBricks removeObject:brick];
        
        // Remove from table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (void)loadMissingBricks {
    // Reset the array so we don't get dupes
    self.missingBricks = [NSMutableArray array];
    
    for (Set *set in self.dataModel.sets) {
        for (Brick *brick in set.bricks) {
            if (brick.missing) {
                [self.missingBricks addObject:brick];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell withBrick:(Brick *)brick {
    UIImageView *brickImageView = [cell viewWithTag:3000];
    UILabel *brickLabel = [cell viewWithTag:3001];
    
    brickImageView.image = brick.brickImage;
    brickLabel.text = brick.itemNumber;
}

@end
