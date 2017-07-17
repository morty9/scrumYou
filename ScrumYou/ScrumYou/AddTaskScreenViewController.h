//
//  AddTaskScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Project.h"
#import "Sprint.h"

@interface AddTaskScreenViewController : UIViewController
{
    __weak IBOutlet UITextField *_taskTitleTextField;
    __weak IBOutlet UITextField *_taskDescriptionTextField;
    __weak IBOutlet UITextField *_taskDifficultyTextField;
    __weak IBOutlet UITextField *_taskDurationTextField;
    __weak IBOutlet UITextField *_taskMembersTextField;
    __weak IBOutlet UITextField *_taskCostTextField;
    __weak IBOutlet UITextField *_taskPriorityTextField;
    
    __weak IBOutlet UISegmentedControl *_prioritySegmentation;
    __weak IBOutlet UISegmentedControl *_categorySegmentation;
    
    __weak IBOutlet UIButton *buttonMembersView;
    __weak IBOutlet UIButton *buttonValidate;
    __weak IBOutlet UIButton *buttonModify;
    __weak IBOutlet UIButton *buttonDelete;
    
    __weak IBOutlet UIPickerView *pickerStatus;
    __weak IBOutlet UIPickerView *pickerSprint;
    
    __weak IBOutlet UIStepper *stepperDuration;
    
    __weak IBOutlet UIView *membersView;
    __weak IBOutlet UIView *sprintView;
    
    __weak IBOutlet UITableView *membersTableView;
    
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UILabel *_labelDescription;
    __weak IBOutlet UILabel *_labelDifficulty;
    __weak IBOutlet UILabel *_labelCost;
    
    NSDictionary* _token_dic;
    
    NSArray* _sprintsByProject;
    
    NSString* _id_task;
    
    Project* _cProject;
    Task* _mTask;
    Sprint* _cSprint;
    
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
@property (weak, nonatomic) UITextField* taskPriorityTextField;
@property (weak, nonatomic) UITextField* taskCostTextField;
@property (weak, nonatomic) UISegmentedControl* prioritySegmentation;
@property (weak, nonatomic) UISegmentedControl* categorySegmentation;
@property (nonatomic) BOOL status;
@property (nonatomic, strong) Task* mTask;
@property (nonatomic, strong) Project* cProject;
@property (nonatomic, strong) Sprint* cSprint;
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelDescription;
@property (nonatomic, weak) UILabel* labelDifficulty;
@property (nonatomic, weak) UILabel* labelCost;
@property (nonatomic, strong) NSArray* sprintsByProject;


@end
