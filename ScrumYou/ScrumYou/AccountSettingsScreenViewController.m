//
//  AccountSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AccountSettingsScreenViewController.h"

@interface AccountSettingsScreenViewController ()

@end

@implementation AccountSettingsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Profil"];
    
    //edit button navbar
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editProfil:)];
    editButton.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    self.navigationItem.rightBarButtonItem = editButton;
    
    //image profil
    profilImage.layer.cornerRadius = profilImage.frame.size.width / 2;
    profilImage.clipsToBounds = YES;
    
    //border name text field
    CALayer *borderName = [CALayer layer];
    CGFloat borderWidthName = 1.5;
    borderName.borderColor = [UIColor darkGrayColor].CGColor;
    borderName.frame = CGRectMake(0, nameTextField.frame.size.height - borderWidthName, nameTextField.frame.size.width, nameTextField.frame.size.height);
    borderName.borderWidth = borderWidthName;
    [nameTextField.layer addSublayer:borderName];
    nameTextField.layer.masksToBounds = YES;
    
    //border firstname text field
    CALayer *borderFirstname = [CALayer layer];
    CGFloat borderWidthFirstname = 1.5;
    borderFirstname.borderColor = [UIColor darkGrayColor].CGColor;
    borderFirstname.frame = CGRectMake(0, firstnameTextField.frame.size.height - borderWidthFirstname, firstnameTextField.frame.size.width, firstnameTextField.frame.size.height);
    borderFirstname.borderWidth = borderWidthFirstname;
    [firstnameTextField.layer addSublayer:borderFirstname];
    firstnameTextField.layer.masksToBounds = YES;
    
    //border nickname text field
    CALayer *borderNickname = [CALayer layer];
    CGFloat borderWidthNickname = 1.5;
    borderNickname.borderColor = [UIColor darkGrayColor].CGColor;
    borderNickname.frame = CGRectMake(0, nicknameTextField.frame.size.height - borderWidthNickname, nicknameTextField.frame.size.width, nicknameTextField.frame.size.height);
    borderNickname.borderWidth = borderWidthNickname;
    [nicknameTextField.layer addSublayer:borderNickname];
    nicknameTextField.layer.masksToBounds = YES;
    
    //border email text field
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1.5;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, emailTextField.frame.size.height - borderWidthEmail, emailTextField.frame.size.width, emailTextField.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [emailTextField.layer addSublayer:borderEmail];
    emailTextField.layer.masksToBounds = YES;
    
    //border password text field
    CALayer *borderPassword = [CALayer layer];
    CGFloat borderWidthPassword = 1.5;
    borderPassword.borderColor = [UIColor darkGrayColor].CGColor;
    borderPassword.frame = CGRectMake(0, pwdTextField.frame.size.height - borderWidthPassword, pwdTextField.frame.size.width, pwdTextField.frame.size.height);
    borderPassword.borderWidth = borderWidthPassword;
    [pwdTextField.layer addSublayer:borderPassword];
    pwdTextField.layer.masksToBounds = YES;
    
}

- (void) editProfil {
    
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
