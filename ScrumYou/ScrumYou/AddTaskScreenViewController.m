//
//  AddTaskScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AddTaskScreenViewController.h"
#import "ScrumBoardScreenViewController.h"

@interface AddTaskScreenViewController ()

@end

@implementation AddTaskScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) designPage {
    
    //navigation bar customization
    self.navigationItem.title = [NSString stringWithFormat:@"Ajouter une tâche"];
    
    UINavigationBar* bar = [self.navigationController navigationBar];
    [bar setHidden:false];
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //border taskTitle text field
    CALayer *borderTaskTitle = [CALayer layer];
    CGFloat borderWidthTaskTitle = 1;
    borderTaskTitle.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskTitle.frame = CGRectMake(0, taskTitleTextField.frame.size.height - borderWidthTaskTitle, taskTitleTextField.frame.size.width, taskTitleTextField.frame.size.height);
    borderTaskTitle.borderWidth = borderWidthTaskTitle;
    [taskTitleTextField.layer addSublayer:borderTaskTitle];
    taskTitleTextField.layer.masksToBounds = YES;
    
    //border taskDescription text field
    CALayer *borderTaskDescription = [CALayer layer];
    CGFloat borderWidthTaskDescription = 1;
    borderTaskDescription.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDescription.frame = CGRectMake(0, taskDescriptionTextField.frame.size.height - borderWidthTaskDescription, taskDescriptionTextField.frame.size.width, taskDescriptionTextField.frame.size.height);
    borderTaskDescription.borderWidth = borderWidthTaskDescription;
    [taskDescriptionTextField.layer addSublayer:borderTaskDescription];
    taskDescriptionTextField.layer.masksToBounds = YES;
    
    //border taskCategory text field
    CALayer *borderTaskCategory = [CALayer layer];
    CGFloat borderWidthTaskCategory = 1;
    borderTaskCategory.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskCategory.frame = CGRectMake(0, taskCategoryTextField.frame.size.height - borderWidthTaskCategory, taskCategoryTextField.frame.size.width, taskCategoryTextField.frame.size.height);
    borderTaskCategory.borderWidth = borderWidthTaskCategory;
    [taskCategoryTextField.layer addSublayer:borderTaskCategory];
    taskCategoryTextField.layer.masksToBounds = YES;
    
    //border taskDifficulty text field
    CALayer *borderTaskDifficulty = [CALayer layer];
    CGFloat borderWidthTaskDifficulty = 1;
    borderTaskDifficulty.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDifficulty.frame = CGRectMake(0, taskDifficultyTextField.frame.size.height - borderWidthTaskDifficulty, taskDifficultyTextField.frame.size.width, taskDifficultyTextField.frame.size.height);
    borderTaskDifficulty.borderWidth = borderWidthTaskDifficulty;
    [taskDifficultyTextField.layer addSublayer:borderTaskDifficulty];
    taskDifficultyTextField.layer.masksToBounds = YES;
    
    //border taskDuration text field
    CALayer *borderTaskDuration = [CALayer layer];
    CGFloat borderWidthTaskDuration = 1;
    borderTaskDuration.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDuration.frame = CGRectMake(0, taskDurationTextField.frame.size.height - borderWidthTaskDuration, taskDurationTextField.frame.size.width, taskDurationTextField.frame.size.height);
    borderTaskDuration.borderWidth = borderWidthTaskDuration;
    [taskDurationTextField.layer addSublayer:borderTaskDuration];
    taskDurationTextField.layer.masksToBounds = YES;
    
    //border taskMembers text field
    /*CALayer *borderTaskMembers = [CALayer layer];
    CGFloat borderWidthTaskMembers = 1;
    borderTaskMembers.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskMembers.frame = CGRectMake(0, taskMembersTextField.frame.size.height - borderWidthTaskMembers, taskMembersTextField.frame.size.width, taskMembersTextField.frame.size.height);
    borderTaskMembers.borderWidth = borderWidthTaskMembers;
    [taskMembersTextField.layer addSublayer:borderTaskMembers];
    taskMembersTextField.layer.masksToBounds = YES;*/
    
    //border taskCost text field
    CALayer *borderTaskCost = [CALayer layer];
    CGFloat borderWidthTaskCost = 1;
    borderTaskCost.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskCost.frame = CGRectMake(0, taskCostTextField.frame.size.height - borderWidthTaskCost, taskCostTextField.frame.size.width, taskCostTextField.frame.size.height);
    borderTaskCost.borderWidth = borderWidthTaskCost;
    [taskCostTextField.layer addSublayer:borderTaskCost];
    taskCostTextField.layer.masksToBounds = YES;
    
    //border taskPriority text field
    /*CALayer *borderTaskPriority = [CALayer layer];
    CGFloat borderWidthTaskPriority = 1;
    borderTaskPriority.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskPriority.frame = CGRectMake(0, taskPriorityTextField.frame.size.height - borderWidthTaskPriority, taskPriorityTextField.frame.size.width, taskPriorityTextField.frame.size.height);
    borderTaskPriority.borderWidth = borderWidthTaskPriority;
    [taskPriorityTextField.layer addSublayer:borderTaskPriority];
    taskPriorityTextField.layer.masksToBounds = YES;*/
    
    
    
}

- (void) cancelButton:(id)sender {
    ScrumBoardScreenViewController* UserVc = [[ScrumBoardScreenViewController alloc] init];
    [self.navigationController pushViewController:UserVc animated:YES];
}
- (IBAction)taskAddMembersButton:(id)sender {
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
