//
//  Instructions+CoreDataProperties.h
//  LegoCollection
//
//  Created by Morgan Davison on 4/15/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Instructions.h"


NS_ASSUME_NONNULL_BEGIN

@interface Instructions (CoreDataProperties)

+ (NSFetchRequest<Instructions *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *downloadSize;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *pdfURL;
@property (nullable, nonatomic, retain) Set *set;

@end

NS_ASSUME_NONNULL_END
