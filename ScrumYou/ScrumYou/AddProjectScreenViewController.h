//
//  AddProjectScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AddProjectScreenViewController : UIViewController
{
    __weak IBOutlet UITextField *projectNameTextField;
    __weak IBOutlet UITextField *addMembersTextField;
    __weak IBOutlet UIButton *addButton;
    
    NSMutableArray<User*>* _users;
    NSArray *arryList;
}

@property (nonatomic, strong) NSMutableArray<User*>* users;

@end
