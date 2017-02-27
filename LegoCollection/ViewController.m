//
//  ViewController.m
//  LegoCollection
//
//  Created by Morgan Davison on 2/25/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

//#import "ViewController.h"
//
//@interface ViewController ()
//
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
// 
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Actions
//
//- (IBAction)search:(UIButton *)sender {
//    [self performSearchRequest];
//}
//
//#pragma mark - Helper methods
//
//- (void)performSearchRequest {
//    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
////    NSURL *url = [NSURL URLWithString:@"https://www.lego.com/en-US/service/rpservice/getproduct?productnumber=31049&isSalesFlow=true"];
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
//
//@end
