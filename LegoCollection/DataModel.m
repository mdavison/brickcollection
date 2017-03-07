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
    
    NSLog(@"documents directory: %@", [self dataFilePath]);
    
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
    NSLog(@"saving sets: %@", self.sets);
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.sets forKey:@"Sets"];
    [archiver finishEncoding];
    [data writeToURL:[self dataFilePath] atomically:YES];
}

- (void)loadSets {
    NSLog(@"Loading sets...");
    NSData *data = [[NSData alloc] initWithContentsOfURL:[self dataFilePath]];
    
    if (!self.sets) {
        self.sets = [NSMutableArray array];
    }
    
    if (data) {
        NSLog(@"Have data");
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.sets = [unarchiver decodeObjectForKey:@"Sets"];
        
        [unarchiver finishDecoding];
    }
}

@end
