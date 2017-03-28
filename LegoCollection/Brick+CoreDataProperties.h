//
//  Brick+CoreDataProperties.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Brick.h"


NS_ASSUME_NONNULL_BEGIN

@interface Brick (CoreDataProperties)

+ (NSFetchRequest<Brick *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *itemNumber;
@property (nullable, nonatomic, retain) NSData *brickImage;
@property (nonatomic) BOOL missing;
@property (nullable, nonatomic, retain) Set *set;

@end

NS_ASSUME_NONNULL_END
