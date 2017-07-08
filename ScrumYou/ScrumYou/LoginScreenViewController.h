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
    NSDictionary* _token;
    
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *pwdTextField;
    __weak IBOutlet UIButton *connectButton;
}

@property (nonatomic, strong) NSDictionary* token;

@end
