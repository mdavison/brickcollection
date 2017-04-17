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
    
    self.haveSet = [self setExistsInCollection];
    
    if (!self.haveSet) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 177.0;
    } else {
        return 112.0;
    }
}


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
        UIActivityIndicatorView *activityIndicator = [cell viewWithTag:1004];
        
        if (self.haveSet) {
            productNameLabel.text = [NSString localizedStringWithFormat:@"\nYou already have that set 😀"];
            [activityIndicator stopAnimating];
        } else {
            productNameLabel.text = self.set.productName;
            productImageView.image = [UIImage imageWithData:self.set.productImage];
            
            if (self.error) {
                NSLog(@"Search Error Code: %lu", self.error.code);
//                if (self.error.code == 3840) {
//                    productNameLabel.text = [NSString localizedStringWithFormat:@"That set could not be found"];
//                } else {
//                    productNameLabel.text = self.error.localizedDescription;
//                }
                
                switch (self.error.code) {
                    case 3840:
                        productNameLabel.text = [NSString localizedStringWithFormat:@"Sorry, I couldn't find that Set."];
                        break;
                    case 18446744073709550614U:
                        productNameLabel.text = [NSString localizedStringWithFormat:@"Oops! I don't think that was a valid set number."];
                        break;
                    default:
                        productNameLabel.text = self.error.localizedDescription;
                        break;
                }
            }
        }
    } else {
        Brick *brick = [self.set.bricks allObjects][indexPath.row];

        UIImageView *brickImageView = [cell viewWithTag:1001];
        UILabel *itemNumberLabel = [cell viewWithTag:1002];
        
        brickImageView.image = [UIImage imageWithData:brick.brickImage];
        itemNumberLabel.text = brick.itemNumber;
    }
}


-(void)parseJSONData {
    // Use a background thread
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        if (!self.error) {
            // Create new Set
            self.set = [[Set alloc] initWithContext:self.managedObjectContext];
            
            [self.navigationItem.rightBarButtonItem setEnabled:true];
            
            // Set properties
            self.set.productName = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductName"];
            self.set.productNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];
            
            NSString *baseImageURL = [self.jsonData objectForKey:@"ImageBaseUrl"];
            
            NSString *productImageString = [baseImageURL stringByAppendingString:[[self.jsonData objectForKey:@"Product"] objectForKey:@"Asset"]];
            NSURL *productImageURL = [NSURL URLWithString:productImageString];
            NSData *productImageData = [NSData dataWithContentsOfURL:productImageURL];
            self.set.productImage = productImageData;
            
            NSArray *bricksJSON = [NSMutableArray arrayWithArray:[self.jsonData objectForKey:@"Bricks"]];
            NSMutableArray *bricks = [NSMutableArray array];
            for (NSDictionary *brickDict in bricksJSON) {
                // Create new brick
                Brick *brick = [[Brick alloc] initWithContext:self.managedObjectContext];
                
                // Set properties
                brick.itemNumber = [NSString stringWithFormat:@"%@", [brickDict objectForKey:@"ItemNo"]];
                
                NSString *brickImage = [brickDict objectForKey:@"Asset"];
                NSURL *brickImageURL = [NSURL URLWithString:[baseImageURL stringByAppendingString:brickImage]];
                NSData *brickImageData = [NSData dataWithContentsOfURL:brickImageURL];
                brick.brickImage = brickImageData;
                brick.set = self.set;
                
                // Add to bricks array
                [bricks addObject:brick];
            }
            
            self.set.bricks = [NSSet setWithArray:bricks];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (bool)setExistsInCollection {
    NSString *searchResultProductNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];

    NSArray *allSets = [Set getAllWithManagedObjectContext:self.managedObjectContext];
    for (Set *set in allSets) {
        if ([set.productNumber isEqualToString:searchResultProductNumber]) {
            return true;
        }
    }
    
    return false;
}


@end
