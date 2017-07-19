//
//  ProjectSettingsScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectSettingsScreenViewController : UIViewController {
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITableView *membersTableView;
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UILabel *membersCount;
    __weak IBOutlet UIView *membersView;
    __weak IBOutlet UILabel *membersTextField;
    __weak IBOutlet UITextField *sprintNameTextField;
    __weak IBOutlet UIDatePicker *sprintEndDate;
    
    __weak IBOutlet UIButton *editButtonMembers;
    __weak IBOutlet UIButton *addSprint;
    __weak IBOutlet UIButton *validateButton;
    
    Project* _currentProject;
    
    NSDictionary* _token_dic;
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSDictionary* token_dic;
@property (nonatomic, strong) Project* currentProject;

@end
