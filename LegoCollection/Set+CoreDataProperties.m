//
//  Set+CoreDataProperties.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Set+CoreDataProperties.h"

@implementation Set (CoreDataProperties)

+ (NSFetchRequest<Set *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Set"];
}

@dynamic productName;
@dynamic productNumber;
@dynamic productImage;
@dynamic bricks;

@end
