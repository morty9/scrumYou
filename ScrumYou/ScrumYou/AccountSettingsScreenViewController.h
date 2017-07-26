//
//  AccountSettingsScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingsScreenViewController : UIViewController
{
    NSDictionary* _token;
    
    NSArray* _projects_by_user;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *nicknameTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *pwdTextField;
    
    __weak IBOutlet UIImageView *profilImage;
    
    __weak IBOutlet UIView *membersView;
    __weak IBOutlet UITableView *membersTableView;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet UILabel *labelUserField;
}

@property (nonatomic, strong) NSDictionary* token;
@property (nonatomic , strong) NSArray* projects_by_user;

@end
