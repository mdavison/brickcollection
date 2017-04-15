//
//  InstructionsDetailViewController.h
//  LegoCollection
//
//  Created by Morgan Davison on 4/11/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface InstructionsDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (nonatomic) NSString *pdfURLString;

@end
