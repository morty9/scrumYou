//
//  AddTaskScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskScreenViewController : UIViewController
{
    __weak IBOutlet UITextField *taskTitleTextField;
    __weak IBOutlet UITextField *taskDescriptionTextField;
    __weak IBOutlet UITextField *taskDifficultyTextField;
    __weak IBOutlet UITextField *taskDurationTextField;
    __weak IBOutlet UITextField *taskMembersTextField;
    __weak IBOutlet UITextField *taskCostTextField;
    
    __weak IBOutlet UISegmentedControl *prioritySegmentation;
    __weak IBOutlet UISegmentedControl *categorySegmentation;
    
    __weak IBOutlet UIButton *buttonColorView;
    __weak IBOutlet UIButton *redColor;
    __weak IBOutlet UIButton *blueColor;
    __weak IBOutlet UIButton *orangeColor;
    __weak IBOutlet UIButton *greenColor;
    __weak IBOutlet UIButton *purpleColor;
    __weak IBOutlet UIButton *yellowColor;
    __weak IBOutlet UIButton *darkBlueColor;
    __weak IBOutlet UIButton *pinkColor;
    __weak IBOutlet UIButton *grayBlueColor;
    __weak IBOutlet UIButton *buttonMembersView;
    
    __weak IBOutlet UIView *colorView;
    __weak IBOutlet UIView *membersView;
    
    __weak IBOutlet UITableView *membersTableView;
    
    NSDictionary* _token_dic;
    
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSDictionary* token_dic;

@end
