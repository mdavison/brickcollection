//
//  Instructions+CoreDataProperties.m
//  LegoCollection
//
//  Created by Morgan Davison on 4/15/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Instructions+CoreDataProperties.h"

@implementation Instructions (CoreDataProperties)

+ (NSFetchRequest<Instructions *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Instructions"];
}

@dynamic desc;
@dynamic downloadSize;
@dynamic image;
@dynamic pdfURL;
@dynamic set;

@end
