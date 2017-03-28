//
//  CoreDataStack.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/21/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

NSPersistentContainer *storeContainer;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [self storeContainer].viewContext;
    }
    return self;
}


- (NSPersistentContainer *)storeContainer {
    if (!storeContainer) {
        storeContainer = [[NSPersistentContainer alloc] initWithName:@"LegoCollection"];
    }
    
    [storeContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *desc, NSError *error) {
        
        if (error) {
            NSLog(@"loadPersistentStoresWithCompletionHandler: persistent container could not load store %@. Error: %@",
                  desc, error.debugDescription);
        }
    }];
    
    return storeContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Error saving to Core Data: %@, %@", error, [error userInfo]);
            //abort(); // Use abort to generate crash log - development only
        }
    }
}

@end
