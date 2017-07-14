//
//  AddTaskScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface AddTaskScreenViewController : UIViewController
{
    __weak IBOutlet UITextField *_taskTitleTextField;
    __weak IBOutlet UITextField *_taskDescriptionTextField;
    __weak IBOutlet UITextField *_taskDifficultyTextField;
    __weak IBOutlet UITextField *_taskDurationTextField;
    __weak IBOutlet UITextField *_taskMembersTextField;
    __weak IBOutlet UITextField *_taskCostTextField;
    
    __weak IBOutlet UISegmentedControl *_prioritySegmentation;
    __weak IBOutlet UISegmentedControl *_categorySegmentation;
    
    __weak IBOutlet UIButton *buttonMembersView;
    __weak IBOutlet UIButton *buttonValidate;
    __weak IBOutlet UIButton *buttonModify;
    
    __weak IBOutlet UIPickerView *pickerStatus;
    
    __weak IBOutlet UIView *membersView;
    
    __weak IBOutlet UITableView *membersTableView;
    
    NSDictionary* _token_dic;
    
    NSString* _id_task;
    
    Task* _mTask;
    
    BOOL _status;
    
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSDictionary* token_dic;
@property (nonatomic, strong) NSString* id_task;
@property (weak, nonatomic) UITextField* taskTitleTextField;
@property (weak, nonatomic) UITextField* taskDescriptionTextField;
@property (weak, nonatomic) UITextField* taskDifficultyTextField;
@property (weak, nonatomic) UITextField* taskDurationTextField;
@property (weak, nonatomic) UITextField* taskMembersTextField;
@property (weak, nonatomic) UITextField* taskCostTextField;
@property (weak, nonatomic) UISegmentedControl* prioritySegmentation;
@property (weak, nonatomic) UISegmentedControl* categorySegmentation;
@property (nonatomic) BOOL status;
@property (nonatomic, strong) Task* mTask;


@end
