//
//  CoreDataStack.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/21/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

@end
