//
//  ResultsTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/26/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "ResultsTableViewController.h"

@interface ResultsTableViewController ()

@property (nonatomic) bool haveSet;
@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *productNumber;
@property (nonatomic) NSData *productImageData;
@property (nonatomic) NSMutableArray *bricks;

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
        return [self.bricks count];
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

- (IBAction)addToSets:(UIBarButtonItem *)sender {
    if (!self.haveSet) {
        Set *set = [[Set alloc] initWithContext:self.managedObjectContext];
        // Set properties
        set.productName = self.productName;
        set.productNumber = self.productNumber;
        set.productImage = self.productImageData;
        
        // Need to loop through all the bricks and add the Set property
        for (Brick *brick in self.bricks) {
            brick.set = set;
        }
        
        // Set the bricks property on Set
        set.bricks = [NSSet setWithArray:self.bricks];
        
        [self.delegate resultsTableViewController:self didFinishAddingSet:set];
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
            productNameLabel.text = self.productName;
            productImageView.image = [UIImage imageWithData:self.productImageData];
            
            if (self.error) {
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
        Brick *brick = self.bricks[indexPath.row];

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
            // Set properties - we can't create a new Set object here because it will get saved and user may not want it
            self.productName = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductName"];
            self.productNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];
            
            NSString *baseImageURL = [self.jsonData objectForKey:@"ImageBaseUrl"];
            
            // Placeholder image in case image not available
            UIImage *imageUnavailable = [UIImage imageNamed:@"SetDetailImageUnavailable"];
            
            NSString *productImageString = [baseImageURL stringByAppendingString:[[self.jsonData objectForKey:@"Product"] objectForKey:@"Asset"]];
            NSURL *productImageURL = [NSURL URLWithString:productImageString];
            NSData *productImageData = [NSData dataWithContentsOfURL:productImageURL];
            // If image unavailable, use the placeholder
            if (!productImageData) {
                productImageData = UIImagePNGRepresentation(imageUnavailable);
            }
            self.productImageData = productImageData;
            
            NSArray *bricksJSON = [NSMutableArray arrayWithArray:[self.jsonData objectForKey:@"Bricks"]];
            self.bricks = [NSMutableArray array];
            
            for (NSDictionary *brickDict in bricksJSON) {
                // Create new brick
                Brick *brick = [[Brick alloc] initWithContext:self.managedObjectContext];
                
                // Brick properties
                brick.itemNumber = [NSString stringWithFormat:@"%@", [brickDict objectForKey:@"ItemNo"]];
                
                NSString *brickImage = [brickDict objectForKey:@"Asset"];
                NSURL *brickImageURL = [NSURL URLWithString:[baseImageURL stringByAppendingString:brickImage]];
                NSData *brickImageData = [NSData dataWithContentsOfURL:brickImageURL];
                if (!brickImageData) {
                    brickImageData = UIImagePNGRepresentation(imageUnavailable);
                }
                
                brick.brickImage = brickImageData;
                
                // Add to bricks array
                [self.bricks addObject:brick];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.navigationItem.rightBarButtonItem setEnabled:true];
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
