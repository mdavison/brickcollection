//
//  InstructionsCollectionViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 4/12/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "InstructionsDetailViewController.h"

@interface InstructionsCollectionViewController : UICollectionViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (nonatomic) Set *set;
@property (nonatomic) NSDictionary *jsonData;

@end
