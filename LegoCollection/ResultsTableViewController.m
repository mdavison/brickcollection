//
//  ResultsTableViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/26/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import "ResultsTableViewController.h"

@interface ResultsTableViewController ()

@end

@implementation ResultsTableViewController

NSString *productName;
NSString *productNumber;
UIImage *productImage;
NSMutableArray *bricks;
NSString *baseImageURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Results";
    
    [self parseJSONData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (bricks) {
            return [bricks count];
        } else {
            return 0;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrickCell" forIndexPath:indexPath];
    }
    
    [self configureCell:cell withSection:indexPath.section indexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 177.0;
    } else {
        return 112.0;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper methods

- (void)configureCell:(UITableViewCell *)cell withSection:(NSInteger)section indexPath:(NSIndexPath *)indexPath {
    if (section == 0) {
        UILabel *productNameLabel = [cell viewWithTag:1000];
        UIImageView *productImageView = [cell viewWithTag:1003];
        
        if (productName) {
            productNameLabel.text = [[productName stringByAppendingString:@": "] stringByAppendingString:productNumber];
        }
        
        if (productImage) {
            productImageView.image = productImage;
        }
    } else {
        if (bricks) {
            NSDictionary *brickDict = bricks[indexPath.row];
            //NSLog(@"index for cell: %ld", (long)indexPath.row);
            
            //cell.textLabel.text = [NSString stringWithFormat:@"%@", [brickDict objectForKey:@"ItemNo"]];
            UIImageView *brickImageView = [cell viewWithTag:1001];
            UILabel *itemNumberLabel = [cell viewWithTag:1002];
            
            NSURL *brickImageURL = [NSURL URLWithString:[baseImageURL stringByAppendingString:[brickDict objectForKey:@"Asset"]]];
            NSData *brickImageData = [NSData dataWithContentsOfURL:brickImageURL];
            brickImageView.image = [UIImage imageWithData:brickImageData];
            
            itemNumberLabel.text = [NSString stringWithFormat:@"Item Number: %@", [brickDict objectForKey:@"ItemNo"]];
        }
    }
}

//- (void)performSearchRequest {
//    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
//    //    NSURL *url = [NSURL URLWithString:@"https://www.lego.com/en-US/service/rpservice/getproduct?productnumber=31049&isSalesFlow=true"];
//    NSString *urlString = [[@"https://www.lego.com/en-US/service/rpservice/getproduct?productnumber=" stringByAppendingString:self.searchTextField.text] stringByAppendingString:@"&isSalesFlow=true"];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    NSString *cookie = @"csAgeAndCountry={\"age\":\"18\",\"countrycode\":\"US\"}";
//    [request addValue:cookie forHTTPHeaderField: @"cookie"];
//    [request addValue:@"en-US" forHTTPHeaderField:@"PROMARKETPREF"];
//
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        //NSLog(@"Got response %@ with error %@.\n", response, error);
//        //NSLog(@"DATA:\n%@\nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//        //        NSDictionary *jsonData = [NSJSONSerialization
//        //                                  JSONObjectWithData:urlData
//        //                                  options:NSJSONReadingMutableContainers
//        //                                  error:&serializeError];
//
//        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//
//        //NSLog(@"json data: %@", jsonData);
//        NSString *baseURL = [jsonData objectForKey:@"ImageBaseUrl"];
//        NSString *productImage = [[jsonData objectForKey:@"Product"] objectForKey:@"Asset"];
//        //NSLog(@"%@%@", baseURL, productImage);
//        NSURL *productImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, productImage]];
//        NSData *imageData = [NSData dataWithContentsOfURL:productImageURL];
//        self.productImageView.image = [UIImage imageWithData:imageData];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //When json is loaded refresh the image
//            self.productImageView.image = [UIImage imageWithData:imageData];
//            [self.productImageView setNeedsLayout];
//        });
//
//
//        //NSLog(@"json data: %@", [jsonData objectForKey:@"Product"]);
//        //NSLog(@"json data: %@", [[jsonData objectForKey:@"Product"] objectForKey:@"Asset"]);
//
//    }] resume];
//}

-(void)parseJSONData {
    productName = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductName"];
    productNumber = [[self.jsonData objectForKey:@"Product"] objectForKey:@"ProductNo"];

    bricks = [NSMutableArray arrayWithArray:[self.jsonData objectForKey:@"Bricks"]];
    
    baseImageURL = [self.jsonData objectForKey:@"ImageBaseUrl"];
    
    NSString *productImageString = [baseImageURL stringByAppendingString:[[self.jsonData objectForKey:@"Product"] objectForKey:@"Asset"]];
    NSURL *productImageURL = [NSURL URLWithString:productImageString];
    NSData *productImageData = [NSData dataWithContentsOfURL:productImageURL];
    productImage = [UIImage imageWithData:productImageData];
    
    [self.tableView reloadData];
}

@end
