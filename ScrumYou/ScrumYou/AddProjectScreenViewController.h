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
    NSDictionary* _token_dic;
    
    __weak IBOutlet UITextField *projectNameTextField;
    __weak IBOutlet UITextField *addMembersTextField;
    __weak IBOutlet UITextField *sprintNameTextField;
    __weak IBOutlet UIDatePicker *sprintEndDate;
    //__weak IBOutlet UIButton *addButton;
    __weak IBOutlet UIView *membersView;
    
    __weak IBOutlet UITableView *membersTableView;
    
    __weak IBOutlet UILabel *labelMembers;
    
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSDictionary* token_dic;

@end
