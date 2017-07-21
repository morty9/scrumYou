//
//  SignUpScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "SignUpScreenViewController.h"
#import "HomeScreenViewController.h"
#import "LoginScreenViewController.h"
#import "APIKeys.h"
#import "CrudUsers.h"

@interface SignUpScreenViewController () {
    
    CrudUsers* Users;
    
}

@end

@implementation SignUpScreenViewController

@synthesize emailTextField = _emailTextField;
@synthesize pwdTextField = _pwdTextField;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize completeNameTextField = _completeNameTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Users = [[CrudUsers alloc] init];
    
    [self designPage];
}

/*
 *  IBAction -> add user to database
 *  Call addUser web service
 */
- (IBAction)didTouchAddUser:(id)sender {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [Users addNickname:self.nicknameTextField.text fullname:self.completeNameTextField.text email:self.emailTextField.text password:self.pwdTextField.text callback:^(NSError *error, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([Users.dict_error valueForKey:@"type"] != nil) {
                    NSString* title = [weakSelf->Users.dict_error valueForKey:@"title"];
                    NSString* message = [weakSelf->Users.dict_error valueForKey:@"message"];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Inscription réussie" message:@"Votre inscription est réussie, veuillez vous connecter." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        LoginScreenViewController* loginVC = [[LoginScreenViewController alloc] init];
                        loginVC.navigationItem.hidesBackButton = YES;
                        [weakSelf.navigationController pushViewController:loginVC animated:true];
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        }
    }];
}

/*
 *  VOID -> design the page
 */
- (void) designPage {
    
    //navigation bar customisation
    self.navigationItem.title = [NSString stringWithFormat:@"S'inscrire"];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0] forKey:NSForegroundColorAttributeName];
    
    
    //border email text field
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1.5;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, _emailTextField.frame.size.height - borderWidthEmail, _emailTextField.frame.size.width, _emailTextField.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [_emailTextField.layer addSublayer:borderEmail];
    _emailTextField.layer.masksToBounds = YES;
    
    //border password text field
    CALayer *borderPwd = [CALayer layer];
    CGFloat borderWidthPwd = 1.5;
    borderPwd.borderColor = [UIColor darkGrayColor].CGColor;
    borderPwd.frame = CGRectMake(0, _pwdTextField.frame.size.height - borderWidthPwd, _pwdTextField.frame.size.width, _pwdTextField.frame.size.height);
    borderPwd.borderWidth = borderWidthPwd;
    [_pwdTextField.layer addSublayer:borderPwd];
    _pwdTextField.layer.masksToBounds = YES;
    
    //border nickname text field
    CALayer *borderNickname = [CALayer layer];
    CGFloat borderWidthNickname = 1.5;
    borderNickname.borderColor = [UIColor darkGrayColor].CGColor;
    borderNickname.frame = CGRectMake(0, _nicknameTextField.frame.size.height - borderWidthNickname, _nicknameTextField.frame.size.width, _nicknameTextField.frame.size.height);
    borderNickname.borderWidth = borderWidthNickname;
    [_nicknameTextField.layer addSublayer:borderNickname];
    _nicknameTextField.layer.masksToBounds = YES;
    
    //border complete name text field
    CALayer *borderCompleteName = [CALayer layer];
    CGFloat borderWidthCompleteName = 1.5;
    borderCompleteName.borderColor = [UIColor darkGrayColor].CGColor;
    borderCompleteName.frame = CGRectMake(0, _completeNameTextField.frame.size.height - borderWidthCompleteName, _completeNameTextField.frame.size.width, _completeNameTextField.frame.size.height);
    borderCompleteName.borderWidth = borderWidthCompleteName;
    [_completeNameTextField.layer addSublayer:borderCompleteName];
    _completeNameTextField.layer.masksToBounds = YES;

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
