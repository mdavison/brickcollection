//
//  Brick+CoreDataProperties.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Brick+CoreDataProperties.h"

@implementation Brick (CoreDataProperties)

+ (NSFetchRequest<Brick *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Brick"];
}

@dynamic itemNumber;
@dynamic brickImage;
@dynamic missing;
@dynamic set;

@end
