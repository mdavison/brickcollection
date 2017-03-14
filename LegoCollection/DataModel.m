//
//  DataModel.m
//  LegoCollection
//
//  Created by Morgan Davison on 3/1/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)init {
    self = [super init];
    
    [self loadSets];
    
    return self;
}


#pragma mark - Saving/Loading data

- (NSURL *)documentsDirectory {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    return paths[0];
}

- (NSURL *)dataFilePath {
    return [[self documentsDirectory] URLByAppendingPathComponent:@"Sets.plist"];
}

- (void)saveSets {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.sets forKey:@"Sets"];
    [archiver finishEncoding];
    [data writeToURL:[self dataFilePath] atomically:YES];
}

- (void)loadSets {
    NSData *data = [[NSData alloc] initWithContentsOfURL:[self dataFilePath]];
    
    if (!self.sets) {
        self.sets = [NSMutableArray array];
    }
    
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.sets = [unarchiver decodeObjectForKey:@"Sets"];
        
        [unarchiver finishDecoding];
    }
}

@end
