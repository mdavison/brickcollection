//
//  InstructionsCollectionViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 4/12/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "InstructionsCollectionViewController.h"

@interface InstructionsCollectionViewController ()

@property (nonatomic) NSMutableArray *instructionsArray;

@end

@implementation InstructionsCollectionViewController

static NSString * const reuseIdentifier = @"InstructionsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"Instructions";
    
    // See if we already have instructions for the current set
    if ([self.set.instructions count] > 0) {
        self.instructionsArray = [NSMutableArray array];
        for (Instructions *instr in self.set.instructions) {
            [self.instructionsArray addObject:instr];
        }
        [self.activityIndicator stopAnimating];
    } else {
        [self searchForInstructions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    InstructionsDetailViewController *controller = (InstructionsDetailViewController *)[segue destinationViewController];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    Instructions *instructions = self.instructionsArray[indexPath.row];
    //controller.pdfURLString = self.instructionsPDFs[indexPath.row];
    controller.pdfURLString = instructions.pdfURL;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [self.instructionsImages count];
    return [self.instructionsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
//    UIImageView *imageView = [cell viewWithTag:1000];
    Instructions *instructions = self.instructionsArray[indexPath.row];
//    NSData *imageData = instructions.image;
//    UIImage *image = [UIImage imageWithData:imageData];
//    imageView.image = image;
    
    [self configureCell:cell withInstructions:instructions];
    
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

- (void)configureCell:(UICollectionViewCell *)cell withInstructions:(Instructions *)instructions {
    UIImageView *imageView = [cell viewWithTag:1000];
    UILabel *downloadSizeLabel = [cell viewWithTag:1001];
    UILabel *descLabel = [cell viewWithTag:1002];
    
    NSData *imageData = instructions.image;
    UIImage *image = [UIImage imageWithData:imageData];
    imageView.image = image;
    
    downloadSizeLabel.text = instructions.downloadSize;
    descLabel.text = instructions.desc;
}

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
        
        NSDictionary *instructions = [[[self.jsonData objectForKey:@"products"]
                                       objectAtIndex:0]
                                      objectForKey:@"buildingInstructions"];
        
        self.instructionsArray = [NSMutableArray array];
        
        for (NSDictionary *instrItems in instructions) {
            // Create new Instructions object
            Instructions *instructions = [[Instructions alloc] initWithContext:self.managedObjectContext];
            
            // Instructions Image
            NSString *instrImageURLString = [instrItems objectForKey:@"frontpageInfo"];
            NSURL *instrImageURL = [NSURL URLWithString:instrImageURLString];
            NSData *imageData = [NSData dataWithContentsOfURL:instrImageURL];
            if (!imageData) {
                // If we couldn't pull the image down from the url, use the placeholder
                UIImage *image = [UIImage imageNamed:@"InstructionsImageUnavailable"];
                imageData = UIImagePNGRepresentation(image);
            }
            instructions.image = imageData;
            
            
            // PDF url
            NSString *pdf = [instrItems objectForKey:@"pdfLocation"];
            if (pdf) {
                instructions.pdfURL = pdf;
            }
            
            // Description, download size
            instructions.desc = [instrItems objectForKey:@"description"];
            instructions.downloadSize = [instrItems objectForKey:@"downloadSize"];
            
            // Add it to the current set
            instructions.set = self.set;
            
            // Add the new instructions object to the instructionsArray
            [self.instructionsArray addObject:instructions];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}

@end
