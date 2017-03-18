//
//  Set.h
//  LegoCollection
//
//  Created by Morgan Davison on 2/28/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Set : NSObject <NSCoding>

@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *productNumber;
@property (nonatomic) UIImage *productImage;
@property (nonatomic) NSMutableArray *bricks;

@end
