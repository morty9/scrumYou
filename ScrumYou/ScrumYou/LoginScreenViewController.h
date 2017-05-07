//
//  LoginScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreenViewController : UIViewController
{
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *pwdTextField;
    __weak IBOutlet UIButton *connectButton;
}

@end
