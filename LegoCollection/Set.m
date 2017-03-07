//
//  Set.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/28/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Set.h"

@implementation Set

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.productName = [aDecoder decodeObjectForKey:@"ProductName"];
    self.productImage = [aDecoder decodeObjectForKey:@"ProductImage"];
    self.bricks = [aDecoder decodeObjectForKey:@"Bricks"];
    
    self = [super init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.productName forKey:@"ProductName"];
    [aCoder encodeObject:self.productImage forKey:@"ProductImage"];
    [aCoder encodeObject:self.bricks forKey:@"Bricks"];
}

@end
