//
//  LoginScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "HomeScreenViewController.h"
#import "UserHomeScreenViewController.h"
#import "CrudAuth.h"

#import "AddProjectScreenViewController.h"

@interface LoginScreenViewController ()

@end

@implementation LoginScreenViewController {
 
    CrudAuth* Auth;
    NSDictionary* token;
    
    AddProjectScreenViewController* addProjectVC;

}

@synthesize token = _token;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    Auth = [[CrudAuth alloc] init];
    addProjectVC = [[AddProjectScreenViewController alloc] init];
}

- (IBAction)connectionButton:(id)sender {
    
    [Auth login:emailTextField.text password:pwdTextField.text callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"CONNECTED");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"AUTH TOKEN %@", Auth.token);
                addProjectVC.token_dic = Auth.token;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:addProjectVC animated:YES];
                });
            });
        }
    }];
}

- (void) designPage {
    
    //navigation bar customization
    self.navigationItem.title = [NSString stringWithFormat:@"Connexion"];
    
    UINavigationBar* bar = [self.navigationController navigationBar];
    [bar setHidden:false];
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //border email text field
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1.5;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, emailTextField.frame.size.height - borderWidthEmail, emailTextField.frame.size.width, emailTextField.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [emailTextField.layer addSublayer:borderEmail];
    emailTextField.layer.masksToBounds = YES;
    
    //border password text field
    CALayer *borderPwd = [CALayer layer];
    CGFloat borderWidthPwd = 1.5;
    borderPwd.borderColor = [UIColor darkGrayColor].CGColor;
    borderPwd.frame = CGRectMake(0, pwdTextField.frame.size.height - borderWidthPwd, pwdTextField.frame.size.width, pwdTextField.frame.size.height);
    borderPwd.borderWidth = borderWidthPwd;
    [pwdTextField.layer addSublayer:borderPwd];
    pwdTextField.layer.masksToBounds = YES;
    
    
    
}

- (void) cancelButton:(id)sender {
    HomeScreenViewController* homeVc = [[HomeScreenViewController alloc] init];
    [self.navigationController pushViewController:homeVc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
