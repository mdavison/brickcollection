//
//  ResultsTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/26/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "ResultsTableViewController.h"

@interface ResultsTableViewController ()

@property Set *set;
@property bool haveSet;

@end


@implementation ResultsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Results";
    
    self.haveSet = [self setExists];
    
    if (self.haveSet) {
        [self.navigationItem.rightBarButtonItem setEnabled:false];
    } else {
        [self parseJSONData];
    }
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
        return [self.set.bricks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsProductCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsBrickCell" forIndexPath:indexPath];
    }
    
    [self configureCell:cell withSection:indexPath.section indexPath:indexPath];
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 177.0;
    } else {
        return 112.0;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.delegate resultsTableViewControllerDidCancel:self];
}

- (IBAction)addToSets:(UIBarButtonItem *)sender {
    if (!self.haveSet) {
        [self.delegate resultsTableViewController:self didFinishAddingSet:self.set];
    }
}


#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withSection:(NSInteger)section indexPath:(NSIndexPath *)indexPath {
    if (section == 0) {
        
        UILabel *productNameLabel = [cell viewWithTag:1000];
        UIImageView *productImageView = [cell viewWithTag:1003];
        
        if (self.haveSet) {
            productNameLabel.text = [NSString localizedStringWithFormat:@"You already have that set 😀"];
        } else {
            productNameLabel.text = self.set.productName;
            productImageView.image = self.set.productImage;
            
            if (self.error) {
                if (self.error.code == 3840) {
                    productNameLabel.text = [NSString localizedStringWithFormat:@"That set could not be found"];
                } else {
                    productNameLabel.text = self.error.localizedDescription;
                }
            }
        }
    } else {
        Brick *brick = self.set.bricks[indexPath.row];

        UIImageView *brickImageView = [cell viewWithTag:1001];
        UILabel *itemNumberLabel = [cell viewWithTag:1002];
        
        brickImageView.image = brick.brickImage;
        itemNumberLabel.text = brick.itemNumber;
    }
}


// TODO: refactor this to data model?
-(void)parseJSONData {
    // Use a background thread
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        // Create new Set
        self.set = [[Set alloc] init];
        
        if (!self.error) {
            // Set properties
            self.set.productName = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductName"];
            self.set.productNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];
            
            NSString *baseImageURL = [self.jsonData objectForKey:@"ImageBaseUrl"];
            
            NSString *productImageString = [baseImageURL stringByAppendingString:[[self.jsonData objectForKey:@"Product"] objectForKey:@"Asset"]];
            NSURL *productImageURL = [NSURL URLWithString:productImageString];
            NSData *productImageData = [NSData dataWithContentsOfURL:productImageURL];
            self.set.productImage = [UIImage imageWithData:productImageData];
            
            NSArray *bricksJSON = [NSMutableArray arrayWithArray:[self.jsonData objectForKey:@"Bricks"]];
            NSMutableArray *bricks = [NSMutableArray array];
            for (NSDictionary *brickDict in bricksJSON) {
                // Create new brick
                Brick *brick = [[Brick alloc] init];
                
                // Set properties
                brick.itemNumber = [NSString stringWithFormat:@"%@", [brickDict objectForKey:@"ItemNo"]];
                
                NSString *brickImage = [brickDict objectForKey:@"Asset"];
                NSURL *brickImageURL = [NSURL URLWithString:[baseImageURL stringByAppendingString:brickImage]];
                NSData *brickImageData = [NSData dataWithContentsOfURL:brickImageURL];
                brick.brickImage = [UIImage imageWithData:brickImageData];
                brick.set = self.set;
                
                // Add to bricks array
                [bricks addObject:brick];
            }
            self.set.bricks = bricks;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (bool)setExists {
    NSString *searchResultProductNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];

    for (Set *set in self.dataModel.sets) {
        if ([set.productNumber isEqualToString:searchResultProductNumber]) {
            return true;
        }
    }
    
    return false;
}


@end
