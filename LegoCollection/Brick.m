//
//  Brick.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "Brick.h"

@implementation Brick

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.itemNumber = [aDecoder decodeObjectForKey:@"ItemNumber"];
    self.brickImage = [aDecoder decodeObjectForKey:@"BrickImage"];
    self.missing = [aDecoder decodeBoolForKey:@"Missing"];
    self.set = [aDecoder decodeObjectForKey:@"Set"];
    
    self = [super init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemNumber forKey:@"ItemNumber"];
    [aCoder encodeObject:self.brickImage forKey:@"BrickImage"];
    [aCoder encodeBool:self.missing forKey:@"Missing"];
    [aCoder encodeObject:self.set forKey:@"Set"];
}

@end
