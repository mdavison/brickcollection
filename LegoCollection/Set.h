//
//  Set+CoreDataClass.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brick;

NS_ASSUME_NONNULL_BEGIN

@interface Set : NSManagedObject

- (NSFetchedResultsController *) getFetchedResultsController;
+ (NSArray *)getAllWithManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Set+CoreDataProperties.h"
