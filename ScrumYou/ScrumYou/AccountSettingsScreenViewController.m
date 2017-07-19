//
//  AccountSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AccountSettingsScreenViewController.h"
#import "LoginScreenViewController.h"
#import "UserHomeScreenViewController.h"
#import "CrudAuth.h"
#import "CrudUsers.h"
#import "HomeScreenViewController.h"

@interface AccountSettingsScreenViewController ()



@end


@implementation AccountSettingsScreenViewController {
    
    NSDictionary* token;
    User* currentUser;
    bool isToUpdate;
    
    CrudAuth* Auth;
    CrudUsers* UsersCrud;
    
    UIBarButtonItem* updateButtonEdit;
    UIBarButtonItem* updateButtonCancel;
}

@synthesize token = _token;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        Auth = [[CrudAuth alloc] init];
        UsersCrud = [[CrudUsers alloc] init];
        currentUser = [[User alloc] init];

        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    Auth = [[CrudAuth alloc] init];
    isToUpdate = NO;

    NSString* userId = [[self.token valueForKey:@"userId"] stringValue];
    
    updateButtonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(enableTextField:)];
    self.navigationItem.rightBarButtonItem = updateButtonEdit;
    updateButtonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(enableTextField:)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UsersCrud getUserById:userId callback:^(NSError *error, BOOL success) {
            if (success) {
            
                currentUser = UsersCrud.user;
            
                [self displayUser:currentUser];
            
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayUser:(User*)curUser {
    labelUserField.text = curUser.fullname;
    nameTextField.text = curUser.fullname;
    nicknameTextField.text = curUser.nickname;
    emailTextField.text = curUser.email;
    pwdTextField.text = curUser.password;
}

- (void) enableTextField:(id)sender {
    if (isToUpdate == NO) {
        saveButton.hidden = false;
        nameTextField.enabled = true;
        nameTextField.textColor = [UIColor lightGrayColor];
        nicknameTextField.enabled = true;
        nicknameTextField.textColor = [UIColor lightGrayColor];
        emailTextField.enabled = true;
        emailTextField.textColor = [UIColor lightGrayColor];
        pwdTextField.enabled = true;
        pwdTextField.textColor = [UIColor lightGrayColor];
        
        isToUpdate = YES;
        self.navigationItem.rightBarButtonItem = updateButtonCancel;

    } else {
        saveButton.hidden = true;
        nameTextField.enabled = false;
        nameTextField.textColor = [UIColor blackColor];
        nameTextField.text = currentUser.fullname;
        nicknameTextField.enabled = false;
        nicknameTextField.textColor = [UIColor blackColor];
        nicknameTextField.text = currentUser.nickname;
        emailTextField.enabled = false;
        emailTextField.textColor = [UIColor blackColor];
        emailTextField.text = currentUser.email;
        pwdTextField.enabled = false;
        pwdTextField.textColor = [UIColor blackColor];
        pwdTextField.text = currentUser.password;
        
        isToUpdate = NO;
        self.navigationItem.rightBarButtonItem = updateButtonEdit;

    }

}

- (IBAction)saveModification:(id)sender {
    
    if (isToUpdate == YES) {
        NSString* tok = [_token valueForKey:@"token"];
        NSString* userId = [_token valueForKey:@"userId"];
        NSString* newNickName = nicknameTextField.text;
        NSString* newUserName = nameTextField.text;
        NSString* newEmail = emailTextField.text;
        NSString* newPass = pwdTextField.text;
        
        [UsersCrud updateUserId:[NSString stringWithFormat:@"%@", userId] nickname:newNickName fullname:newUserName email:newEmail password:newPass token:tok callback:^(NSError *error, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Modifications" message:@"Les modifications ont bien été prises en compte." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        UserHomeScreenViewController* userHomeVC = [[UserHomeScreenViewController alloc] init];
                        userHomeVC.token = self.token;
                        [self.navigationController pushViewController:userHomeVC animated:YES];
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }];
    }
}

- (IBAction)deleteAccountUser:(id)sender {
    NSString* tok = [_token valueForKey:@"token"];
    NSString* userId = [_token valueForKey:@"userId"];

    [UsersCrud deleteUserWithId:[NSString stringWithFormat:@"%@", userId] token:tok callback:^(NSError *error, BOOL success) {
        if (success) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Suppression de l'utilisateur" message:@"La suppression de l'utilisateur a bien été prise en compte." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                HomeScreenViewController* homeVc = [[HomeScreenViewController alloc] init];
                [self.navigationController pushViewController:homeVc animated:YES];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}



- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Profil"];
    
    //edit button navbar
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editProfil:)];
//    editButton.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
//    self.navigationItem.rightBarButtonItem = editButton;
    
    //image profil
    profilImage.layer.cornerRadius = profilImage.frame.size.width / 2;
    profilImage.clipsToBounds = YES;
    
    //border name text field
    CALayer *borderName = [CALayer layer];
    CGFloat borderWidthName = 1;
    borderName.borderColor = [UIColor darkGrayColor].CGColor;
    borderName.frame = CGRectMake(0, nameTextField.frame.size.height - borderWidthName, nameTextField.frame.size.width, nameTextField.frame.size.height);
    borderName.borderWidth = borderWidthName;
    [nameTextField.layer addSublayer:borderName];
    nameTextField.layer.masksToBounds = YES;
    
    //border firstname text field
//    CALayer *borderFirstname = [CALayer layer];
//    CGFloat borderWidthFirstname = 1;
//    borderFirstname.borderColor = [UIColor darkGrayColor].CGColor;
//    borderFirstname.frame = CGRectMake(0, firstnameTextField.frame.size.height - borderWidthFirstname, firstnameTextField.frame.size.width, firstnameTextField.frame.size.height);
//    borderFirstname.borderWidth = borderWidthFirstname;
//    [firstnameTextField.layer addSublayer:borderFirstname];
//    firstnameTextField.layer.masksToBounds = YES;
    
    //border nickname text field
    CALayer *borderNickname = [CALayer layer];
    CGFloat borderWidthNickname = 1;
    borderNickname.borderColor = [UIColor darkGrayColor].CGColor;
    borderNickname.frame = CGRectMake(0, nicknameTextField.frame.size.height - borderWidthNickname, nicknameTextField.frame.size.width, nicknameTextField.frame.size.height);
    borderNickname.borderWidth = borderWidthNickname;
    [nicknameTextField.layer addSublayer:borderNickname];
    nicknameTextField.layer.masksToBounds = YES;
    
    //border email text field
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, emailTextField.frame.size.height - borderWidthEmail, emailTextField.frame.size.width, emailTextField.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [emailTextField.layer addSublayer:borderEmail];
    emailTextField.layer.masksToBounds = YES;
    
    //border password text field
    CALayer *borderPassword = [CALayer layer];
    CGFloat borderWidthPassword = 1;
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
