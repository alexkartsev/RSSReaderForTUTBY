//
//  DetailViewController.m
//  RSSReader
//
//  Created by Александр Карцев on 1/17/16.
//  Copyright © 2016 Alex Kartsev. All rights reserved.
//

#import "WebDetailViewController.h"
#import "MBProgressHUD.h"

@interface WebDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSURL *tempURL = [NSURL URLWithString:self.item.link];
    if (!tempURL) {
        [self showAlertViewWithMessage:@"Invalid URL"];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:tempURL];
    [self.myWebView loadRequest:requestObj];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlertViewWithMessage:@"Error downloading, sorry..."];
}

- (void) showAlertViewWithMessage:(NSString *) message {
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Attention!"  message:message  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
