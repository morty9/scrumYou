//
//  ErrorsViewController.m
//  Scrummary
//
//  Created by Bérangère La Touche on 25/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ErrorsViewController.h"

@interface ErrorsViewController ()

@end

@implementation ErrorsViewController

- (void) bddErrorsTitle:(NSString*)title message:(NSString*)message viewController:(UIViewController*)viewController {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    [viewController presentViewController:alert animated:YES completion:nil];
    
}

@end
