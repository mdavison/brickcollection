//
//  Brick.h
//  LegoCollection
//
//  Created by Morgan Davison on 3/4/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"

@interface Brick : NSObject <NSCoding>

@property (nonatomic) NSString *itemNumber;
@property (nonatomic) UIImage *brickImage;
@property (nonatomic) bool missing;
@property (nonatomic) Set *set;

@end
