//
//  Set+CoreDataProperties.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/23/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Set.h"


NS_ASSUME_NONNULL_BEGIN

@interface Set (CoreDataProperties)

+ (NSFetchRequest<Set *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *displayOrder;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSString *productNumber;
@property (nullable, nonatomic, retain) NSData *productImage;
@property (nullable, nonatomic, retain) NSSet<Brick *> *bricks;
@property (nullable, nonatomic, retain) NSSet<Instructions *> *instructions;

@end

@interface Set (CoreDataGeneratedAccessors)

- (void)addBricksObject:(Brick *)value;
- (void)removeBricksObject:(Brick *)value;
- (void)addBricks:(NSSet<Brick *> *)values;
- (void)removeBricks:(NSSet<Brick *> *)values;

@end

NS_ASSUME_NONNULL_END
