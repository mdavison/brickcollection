//
//  SetTests.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/28/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Set.h"
#import "CoreDataStack.h"

@interface SetTests : XCTestCase

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation SetTests

// Test objects
Set *set1;
Set *set2;
Set *set3;

- (void)setUp {
    [super setUp];
    
    NSPersistentContainer *storeContainer = [[NSPersistentContainer alloc] initWithName:@"LegoCollection"];
    self.managedObjectContext = storeContainer.viewContext;
    
    set1 = [[Set alloc] initWithContext:self.managedObjectContext];
    set2 = [[Set alloc] initWithContext:self.managedObjectContext];
    set3 = [[Set alloc] initWithContext:self.managedObjectContext];
}

- (void)tearDown {
    // Delete all sets from database
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Set" inManagedObjectContext:self.managedObjectContext]];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    for (Set *set in results) {
        [self.managedObjectContext deleteObject:set];
    }
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testGetAll {
    NSArray *allSets = [Set getAllWithManagedObjectContext:self.managedObjectContext];
    
    // Count should be 3
    XCTAssertEqual(3, allSets.count);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


@end
