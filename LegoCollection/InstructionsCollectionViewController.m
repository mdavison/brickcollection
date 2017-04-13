//
//  InstructionsCollectionViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 4/12/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "InstructionsCollectionViewController.h"

@interface InstructionsCollectionViewController ()

@property (nonatomic) NSMutableArray *instructionsImages;
@property (nonatomic) NSMutableArray *instructionsPDFs;

@end

@implementation InstructionsCollectionViewController

static NSString * const reuseIdentifier = @"InstructionsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"Instructions";
    
    // Do any additional setup after loading the view.
    self.instructionsImages = [NSMutableArray array];
    self.instructionsPDFs = [NSMutableArray array];
    
    [self searchForInstructions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    InstructionsDetailViewController *controller = (InstructionsDetailViewController *)[segue destinationViewController];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    controller.pdfURLString = self.instructionsPDFs[indexPath.row];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.instructionsImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *imageView = [cell viewWithTag:1000];
    imageView.image = self.instructionsImages[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma mark - Helper methods

- (void)searchForInstructions {
    // Add network request indicator to status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    
    NSString *urlString = [@"https://www.lego.com//service/biservice/search?fromIndex=0&locale=en-US&onlyAlternatives=false&prefixText=" stringByAppendingString:self.set.productNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            self.jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error != NULL) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                [self parseJSONData];
            }
        });
        
    }] resume];
}

-(void)parseJSONData {
    // Use a background thread
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    dispatch_async(queue, ^{
        
        //        NSLog(@"instructionsImages: %@", [[[self.jsonData objectForKey:@"products"] objectAtIndex:0] objectForKey:@"buildingInstructions"]);
        
        NSDictionary *instructions = [[[self.jsonData objectForKey:@"products"]
                                       objectAtIndex:0]
                                      objectForKey:@"buildingInstructions"];
        
        for (NSDictionary *instrItems in instructions) {
            NSString *instrImageURLString = [instrItems objectForKey:@"frontpageInfo"];
            NSURL *instrImageURL = [NSURL URLWithString:instrImageURLString];
            NSData *imageData = [NSData dataWithContentsOfURL:instrImageURL];
            UIImage *image = [UIImage imageWithData:imageData];
            //[self.instructionsImages addObject:[instrItems objectForKey:@"frontpageInfo"]];
            [self.instructionsImages addObject:image];
            [self.instructionsPDFs addObject:[instrItems objectForKey:@"pdfLocation"]];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}

@end
