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
    __weak IBOutlet UITextField *taskCategoryTextField;
    __weak IBOutlet UITextField *taskDifficultyTextField;
    __weak IBOutlet UITextField *taskDurationTextField;
    __weak IBOutlet UITextField *taskMembersTextField;
    __weak IBOutlet UITextField *taskCostTextField;
    __weak IBOutlet UITextField *taskPriorityTextField;
    __weak IBOutlet UITextField *taskColorTextField;
    __weak IBOutlet UIButton *addTaskMembersButton;
    __weak IBOutlet UIButton *addTaskButton;
}

@end
