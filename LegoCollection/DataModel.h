//
//  DataModel.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/1/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic) NSMutableArray *sets;

- (void)saveSets;

@end
