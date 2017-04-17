//
//  SetTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/28/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "SetTableViewController.h"
#import "Set.h"

@interface SetTableViewController ()

@end


@implementation SetTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    
    Set *set = (Set *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withSet:set];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath: indexPath]];
    }   
}


// Allow rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Set displayOrder property whenever rearranging occurs
    NSMutableArray *allSets = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    NSManagedObject *setBeingMoved = [[self fetchedResultsController] objectAtIndexPath:fromIndexPath];
    
    // Remove the set being moved from the array
    [allSets removeObject:setBeingMoved];
    
    // Now re-insert it at the destination.
    [allSets insertObject:setBeingMoved atIndex:[toIndexPath row]];
    
    // All sets are now in their correct order - set the displayOrder property on each
    int i = 1;
    for (Set *set in allSets) {
        [set setValue:[NSNumber numberWithInt:i++] forKey:@"displayOrder"];
    }
    
    [self.managedObjectContext save:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SetDetailTableViewController *controller = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    controller.set = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.managedObjectContext = self.managedObjectContext;
}


#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withSet:(Set *)set {
    UIImageView *setImageView = [cell viewWithTag:1000];
    if (set.productImage) {
        setImageView.image = [UIImage imageWithData:set.productImage];
    } else {
        setImageView.image = [UIImage imageNamed:@"SetsImageUnavailable"];
    }
    
    UILabel *setNameLabel = [cell viewWithTag:1001];
    setNameLabel.text = set.productName;
    
    UILabel *setNumberLabel = [cell viewWithTag:1002];
    setNumberLabel.text = set.productNumber;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Set" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *displayOrderSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSSortDescriptor *productNameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[displayOrderSortDescriptor, productNameSortDescriptor]];
    
    // Relationship paths for prefetching
    fetchRequest.relationshipKeyPathsForPrefetching = [NSArray arrayWithObject:@"bricks"];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unable to perform fetch for Set %@, %@", error, [error userInfo]);
        
        // Alert user
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:[NSString localizedStringWithFormat:@"%@", @"Error"]
                                              message:[NSString localizedStringWithFormat:@"%@", @"There was a problem loading your data."]
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //abort(); // Could abort here if need to generate crash log
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withSet:(Set *)anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

@end
