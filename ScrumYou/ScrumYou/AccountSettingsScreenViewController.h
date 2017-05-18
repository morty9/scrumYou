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
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *firstnameTextField;
    __weak IBOutlet UITextField *nicknameTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *pwdTextField;
    __weak IBOutlet UIImageView *profilImage;
}

@end
