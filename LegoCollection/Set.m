//
//  Set+CoreDataClass.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Set.h"
#import "Brick.h"
@implementation Set

-(NSFetchedResultsController *) getFetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set the entity name
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Set" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Set the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productName" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Relationship paths for prefetching
    fetchRequest.relationshipKeyPathsForPrefetching = [NSArray arrayWithObject:@"bricks"];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil cacheName:nil];
}

+ (NSArray *)getAllWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Set"];
    // Relationship paths for prefetching
    fetchRequest.relationshipKeyPathsForPrefetching = [NSArray arrayWithObject:@"bricks"];
    
    NSError *error = nil;
    NSArray *sets = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error fetching medications: %@", error);
    }
    
    return sets;
}

@end
