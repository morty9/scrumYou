//
//  AddTaskScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AddTaskScreenViewController.h"
#import "ScrumBoardScreenViewController.h"
#import "UserHomeScreenViewController.h"
#import "APIKeys.h"
#import "CrudUsers.h"
#import "CrudTasks.h"
#import "CrudSprints.h"

@interface AddTaskScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIPickerViewDelegate, UIPickerViewDataSource>

- (void) editTask;

@end

@implementation AddTaskScreenViewController {
    ScrumBoardScreenViewController* scrumBoardVC;
    UserHomeScreenViewController* userHomeVC;
    
    NSMutableArray<User*>* get_users;
    NSMutableArray<Sprint*>* get_sprints;
    NSMutableArray<User*>* users_in;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResultsUser;
    NSArray* statusArray;
    
    UIVisualEffectView *blurEffectView;
    
    NSString* statusTask;
    
    NSNumber* ids_sprint;
    NSInteger priority;
    NSInteger nMember;
    NSInteger nMemberTask;
    NSInteger category;
    
    Task* newTask;
    Sprint* spr;
    
    NSDate* currentDate;
    
    CrudUsers* Users;
    CrudTasks* Tasks;
    CrudSprints* Sprints;
    
    BOOL isModify;
    BOOL sprintChoosen;
}

@synthesize token_dic = _token_dic;
@synthesize id_task = _id_task;
@synthesize taskTitleTextField = _taskTitleTextField;
@synthesize taskDescriptionTextField = _taskDescriptionTextField;
@synthesize taskDifficultyTextField = _taskDifficultyTextField;
@synthesize taskCostTextField = _taskCostTextField;
@synthesize taskDurationTextField = _taskDurationTextField;
@synthesize taskMembersTextField = _taskMembersTextField;
@synthesize taskPriorityTextField = _taskPriorityTextField;
@synthesize prioritySegmentation = _prioritySegmentation;
@synthesize categorySegmentation = _categorySegmentation;
@synthesize status = _status;
@synthesize mTask = _mTask;
@synthesize cProject = _cProject;
@synthesize cSprint = _cSprint;
@synthesize labelTitle = _labelTitle;
@synthesize labelDescription = _labelDescription;
@synthesize labelCost = _labelCost;
@synthesize labelDifficulty = _labelDifficulty;
@synthesize sprintsByProject = _sprintsByProject;
@synthesize editButton = _editButton;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self != nil) {
        
        Users = [[CrudUsers alloc] init];
        Tasks = [[CrudTasks alloc] init];
        Sprints = [[CrudSprints alloc] init];
        
        newTask = [[Task alloc] init];
        spr = [[Sprint alloc] init];
        
        get_users = [[NSMutableArray<User*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        users_in = [[NSMutableArray<User*> alloc] init];
        
        members = [[NSMutableArray alloc] init];
        ids = [[NSMutableArray alloc] init];
        
        isModify = NO;
        sprintChoosen = NO;
        self.status = false;
        statusTask = @"A faire";
        statusArray = @[@"A faire", @"En cours", @"Finies"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self getUsers];
    [self getUserByTask];
    
    pickerStatus.delegate = self;
    pickerStatus.dataSource = self;
    
    pickerSprint.delegate = self;
    pickerSprint.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    membersTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    buttonValidate.hidden = YES;
    buttonModify.hidden = YES;
    buttonDelete.hidden = YES;
    
    [membersTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //[super viewDidLoad];
    [self designPage];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (thePickerView == pickerStatus) {
        return statusArray.count;
    } else {
        return self.sprintsByProject.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView == pickerStatus) {
        return [statusArray objectAtIndex:row];
    } else {
        spr = [self.sprintsByProject objectAtIndex:0];
        return [[self.sprintsByProject objectAtIndex:row] valueForKey:@"title"];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (thePickerView == pickerStatus) {
        statusTask = [statusArray objectAtIndex:row];
    } else {
        spr = [self.sprintsByProject objectAtIndex:row];
        NSLog(@"SPR %@", spr.id_sprint);
    }
    
}

// SPRINTS VIEW

/*
 * Show sprint view
 */
- (void)showSprintView {
    /*if ([sender tag] == 1) {
        isModify = true;
    }*/
    [sprintView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:sprintView];
}

/**
 * Close sprint windows
 **/
- (IBAction)closeWindowSprint:(id)sender {
    [sprintView setHidden:true];
    [blurEffectView removeFromSuperview];
}

/*
 *  Validate sprint
 *  Call method who add task to database
 *  Call update sprint web service
 */
- (IBAction)validateSprint:(id)sender {
    /*if (isModify == true) {
        [self ValidateSprintandModifyTask];
        isModify = false;
    } else {
        [self finalValidationTask];
    }*/
    
    NSLog(@"id task %@", self.id_task);
    
    NSMutableArray* list_task = [[NSMutableArray alloc] initWithArray:spr.id_listTasks];
    
    for (int i = 0; i < list_task.count; i++) {
        if (list_task[i] == newTask.id_task) {
            [list_task removeObjectAtIndex:i];
        }
    }
    
    [list_task addObject:newTask.id_task];
    spr.id_listTasks = list_task;
    
    NSString* id_sprint = [NSString stringWithFormat:@"%@", spr.id_sprint];
    NSString* title = spr.title;
    NSString* beginning_date = spr.beginningDate;
    NSString* end_date = spr.endDate;
    NSMutableArray* id_members = spr.id_members;
    
    [Sprints updateSprintId:id_sprint title:title beginningDate:beginning_date endDate:end_date id_members:id_members id_listTasks:list_task token:[self.token_dic valueForKey:@"tokenId"] callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"UPDATE SPRINT SUCCESS");
        }
    }];
    
    userHomeVC = [[UserHomeScreenViewController alloc] init];
    scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", self.cProject.id_project];
    scrumBoardVC.token = self.token_dic;
    NSLog(@"TOKEN DU SCRUMBOARD %@", scrumBoardVC.token);
    
    [self.navigationController pushViewController:scrumBoardVC animated:YES];
    
}

- (IBAction)updateTask:(id)sender {
    
    NSString* current_dateString;
    
    NSLog(@"STATUS %@", statusTask);
    
    [self getIdUser];
    
    newTask.id_task = self.id_task;
    
    if ([statusTask isEqualToString:@"Finies"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        currentDate = [NSDate date];
        current_dateString = [formatter stringFromDate:currentDate];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"00-00-0000"];
        currentDate = [NSDate date];
        current_dateString = [formatter stringFromDate:currentDate];
        NSLog(@"CURRENT DATE : %@", currentDate);
    }
    
    [Tasks updateTaskId:[NSString stringWithFormat:@"%@", self.id_task] title:self.taskTitleTextField.text description:self.taskDescriptionTextField.text difficulty:self.taskDifficultyTextField.text priority:[NSNumber numberWithInteger:priority] id_category:[NSNumber numberWithInteger:category] businessValue:self.taskCostTextField.text duration:self.taskDurationTextField.text status:statusTask id_members:ids taskDone:current_dateString token:[self.token_dic valueForKey:@"tokenId"] callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"UPDATE SUCCESS");
            if ([Tasks.dict_error valueForKey:@"type"] != nil) {
                NSString* title = [Tasks.dict_error valueForKey:@"title"];
                NSString* message = [Tasks.dict_error valueForKey:@"message"];
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Modification réussie" message:@"Votre tâche a été modifiée." preferredStyle:UIAlertControllerStyleAlert];
                        
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [self showSprintView];
                        scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
                        scrumBoardVC.comeUpdateTask = true;
                    }];
                        
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                        
                });
                
            }
        }
    }];
    
}

- (IBAction)validateNewTask:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [Tasks addTaskTitle:self.taskTitleTextField.text description:self.taskDescriptionTextField.text difficulty:self.taskDifficultyTextField.text priority:[NSNumber numberWithInteger:priority] id_category:[NSNumber numberWithInteger:category] businessValue:self.taskCostTextField.text duration:self.taskDurationTextField.text status:statusTask id_members:ids token:[self.token_dic valueForKey:@"tokenId"] callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD TASK");
            if ([Tasks.dict_error valueForKey:@"type"] != nil) {
                NSString* title = [weakSelf->Tasks.dict_error valueForKey:@"title"];
                NSString* message = [weakSelf->Tasks.dict_error valueForKey:@"message"];
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                }];
                
                [alert addAction:defaultAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            } else {
                newTask = Tasks.task;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Création réussie" message:@"Votre tâche a été créée." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [weakSelf showSprintView];
                        scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
                        weakSelf->scrumBoardVC.comeAddTask = true;
                        //scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
                        //weakSelf->scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", weakSelf.cProject.id_project];
                        //[weakSelf.navigationController pushViewController:weakSelf->scrumBoardVC animated:YES];
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                });
            }
        }
    }];
    
    self.taskTitleTextField.text = @"";
    self.taskDescriptionTextField.text = @"";
    self.taskDifficultyTextField.text = @"";
    self.taskMembersTextField.text = @"";
    self.taskCostTextField.text = @"";
    self.taskDurationTextField.text = @"";
    [self.categorySegmentation setSelectedSegmentIndex:0];
    [self.prioritySegmentation setSelectedSegmentIndex:0];
}


- (IBAction)deleteTask:(id)sender {
    
    newTask.id_task = self.id_task;
    
    NSLog(@"SPR %@", self.cSprint.id_sprint);
    
    [Tasks deleteTaskWithId:[NSString stringWithFormat:@"%@", newTask.id_task] andIdSprint:[NSString stringWithFormat:@"%@", self.cSprint.id_sprint] token:[self.token_dic valueForKey:@"tpkenId"] callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"DELETE TASK SUCCESS");

            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Supression réussie" message:@"Votre tâche a été supprimée." preferredStyle:UIAlertControllerStyleAlert];
                    
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
                    scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", self.cProject.id_project];
                    scrumBoardVC.comeDeleteTask = true;
                    scrumBoardVC.token = _token_dic;
                    [self.navigationController pushViewController:scrumBoardVC animated:YES];
                        
                }];
                    
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                    
            });
        }
    }];
    
}


/**
 * MEMBERS VIEW
**/

/**
 * Show add members view
**/
- (IBAction)showAddMembersView:(id)sender {
    [membersView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:membersView];
}

/**
 *  VOID ->
 *  Get users form database
 **/
- (void) getUsername {
    get_users = Users.userList;
    [membersTableView reloadData];
}

/**
 * Get users form database
 **/
- (void) getUsers {
    [Users getUsers:^(NSError *error, BOOL success) {
        if (success) {
            get_users = Users.userList;
            NSLog(@"USERS %@", get_users);
            [membersTableView reloadData];
        }
    }];
}

/*
 *  VOID -> get all users link to the current project
 *  Call getUserById web service
 */
- (void) getUserByTask {
    
    for (NSNumber* membersArray in self.mTask.id_members) {
        NSString* result = [NSString stringWithFormat:@"%@",membersArray];
        [Users getUserById:result callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS USERS IN");
                [users_in addObject:Users.user];
                nMemberTask = users_in.count;
                self.taskMembersTextField.text = [@(nMemberTask)stringValue];
            }
            [membersTableView reloadData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResultsUser.count;
    }else {
        return [get_users count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* const kCellId = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    User* username;
    if(self.searchController.isActive) {
        username = [searchResultsUser objectAtIndex:indexPath.row];
    }else {
        username = [get_users objectAtIndex:indexPath.row];
    }
    
    for (User* user in users_in) {
        if ([user.fullname isEqualToString:[get_users objectAtIndex:indexPath.row].fullname]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            nMember+=1;
            [members addObject:user.fullname];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
        }
        
    }
    
    cell.textLabel.text = username.fullname;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [membersTableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType) {
        cell.accessoryType = NO;
        [members removeObject:cell.textLabel.text];
        nMember-=1;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [members addObject:cell.textLabel.text];
        nMember+=1;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [membersTableView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSPredicate *predicateUser = [NSPredicate predicateWithFormat:@"fullname contains[c] %@ OR nickname contains[c] %@", searchText, searchText];
    searchResultsUser = [get_users filteredArrayUsingPredicate:predicateUser];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


/**
 * Get id User from get_users dictionary
**/
- (void) getIdUser {
    [ids removeAllObjects];
    for (NSString* name in members) {
        for (User* user in get_users) {
            if ([name isEqualToString:[user valueForKey:@"fullname"]]) {
                NSString* uId = [user valueForKey:@"id_user"];
                if ([self cleanOccurrences:uId] == false) {
                    [ids addObject:uId];
                }
            }
        }
    }
}

/**
 * Clean occurrences - check if key exist in array
**/
- (BOOL) cleanOccurrences:(NSString*)key {
    for (NSString* keys in ids) {
        if (keys == key) {
            return true;
        }
    }
    return false;
}

/**
 * Validate members
**/
- (IBAction)validateMembers:(id)sender {
    [membersView setHidden:true];
    [blurEffectView removeFromSuperview];
    self.taskMembersTextField.text = [@(nMember)stringValue];
    if(self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
    [self getIdUser];
    NSLog(@"MEMBERS %@", members);
}

/**
 * Close members windows
**/
- (IBAction)closeWindowMembers:(id)sender {
    [membersView setHidden:true];
    [blurEffectView removeFromSuperview];
    if(self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
}


/**
 * Priority segmented control
**/
- (IBAction)priorityChanged:(UISegmentedControl *)sender {
    priority = [sender selectedSegmentIndex];
}


/**
 * Category segmented control
**/
- (IBAction)categoryChanged:(UISegmentedControl *)sender {
    category = [sender selectedSegmentIndex];
}


/**
 * Stepper task duration
**/
- (IBAction)stepperAction:(UIStepper*)sender {
    NSUInteger value = sender.value;
    self.taskDurationTextField.text = [NSString stringWithFormat:@"%02lu", (unsigned long)value];
}

/**
 * Design the page
**/
- (void) designPage {
    
    //navigation bar customization
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editTask)];
    self.editButton.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    self.navigationItem.rightBarButtonItem = self.editButton;

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.21 blue:0.27 alpha:1.0];

    if (self.status == 0) {
        self.navigationItem.title = @"Ajouter une tâche";
        buttonValidate.hidden = NO;
        buttonModify.hidden = YES;
        buttonDelete.hidden = YES;
        
    } else {
        self.navigationItem.title = self.mTask.title;
        
        buttonModify.hidden = YES;
        buttonDelete.hidden = YES;
        
        self.taskTitleTextField.enabled = false;
        self.taskCostTextField.enabled = false;
        self.taskDurationTextField.enabled = false;
        self.taskDifficultyTextField.enabled = false;
        self.prioritySegmentation.enabled = false;
        self.categorySegmentation.enabled = false;
        self.taskDescriptionTextField.enabled = false;
        self.taskMembersTextField.enabled = false;
        buttonMembersView.enabled = false;
        pickerStatus.userInteractionEnabled = false;
        stepperDuration.enabled = false;
        
        
        self.id_task = self.mTask.id_task;
        self.taskTitleTextField.text = self.mTask.title;
        self.taskDescriptionTextField.text = self.mTask.description;
        self.taskDifficultyTextField.text = [NSString stringWithFormat:@"%@",self.mTask.difficulty];
        self.taskMembersTextField.text = [NSString stringWithFormat:@"%ld", self.mTask.id_members.count];
        self.taskCostTextField.text = [NSString stringWithFormat:@"%@" ,self.mTask.businessValue];
        self.taskDurationTextField.text = [NSString stringWithFormat:@"%@",self.mTask.duration];
        [self.categorySegmentation setSelectedSegmentIndex:[self.mTask.id_category integerValue]];
        [self.prioritySegmentation setSelectedSegmentIndex:[self.mTask.priority integerValue]-1];
        
    }
    
    //border taskTitle text field
    CALayer *borderTaskTitle = [CALayer layer];
    CGFloat borderWidthTaskTitle = 1;
    borderTaskTitle.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskTitle.frame = CGRectMake(0, self.labelTitle.frame.size.height - borderWidthTaskTitle, self.labelTitle.frame.size.width, self.labelTitle.frame.size.height);
    borderTaskTitle.borderWidth = borderWidthTaskTitle;
    [self.labelTitle.layer addSublayer:borderTaskTitle];
    self.labelTitle.layer.masksToBounds = YES;
    
    //border taskDescription text field
    CALayer *borderTaskDescription = [CALayer layer];
    CGFloat borderWidthTaskDescription = 1;
    borderTaskDescription.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDescription.frame = CGRectMake(0, self.labelDescription.frame.size.height - borderWidthTaskDescription, self.labelDescription.frame.size.width, self.labelDescription.frame.size.height);
    borderTaskDescription.borderWidth = borderWidthTaskDescription;
    [self.labelDescription.layer addSublayer:borderTaskDescription];
    self.labelDescription.layer.masksToBounds = YES;
    
    //border taskDifficulty text field
    CALayer *borderTaskDifficulty = [CALayer layer];
    CGFloat borderWidthTaskDifficulty = 1;
    borderTaskDifficulty.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDifficulty.frame = CGRectMake(0, self.labelDifficulty.frame.size.height - borderWidthTaskDifficulty, self.labelDifficulty.frame.size.width, self.labelDifficulty.frame.size.height);
    borderTaskDifficulty.borderWidth = borderWidthTaskDifficulty;
    [self.labelDifficulty.layer addSublayer:borderTaskDifficulty];
    self.labelDifficulty.layer.masksToBounds = YES;
    
    //border taskCost text field
    CALayer *borderTaskCost = [CALayer layer];
    CGFloat borderWidthTaskCost = 1;
    borderTaskCost.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskCost.frame = CGRectMake(0, self.labelCost.frame.size.height - borderWidthTaskCost, self.labelCost.frame.size.width, self.labelCost.frame.size.height);
    borderTaskCost.borderWidth = borderWidthTaskCost;
    [self.labelCost.layer addSublayer:borderTaskCost];
    self.labelCost.layer.masksToBounds = YES;
    
    //border radius member view
    membersView.layer.cornerRadius = 2.0;
    
}

- (void) editTask {
    buttonModify.hidden = NO;
    buttonDelete.hidden = NO;
    
    self.taskTitleTextField.enabled = true;
    self.taskCostTextField.enabled = true;
    self.taskDurationTextField.enabled = true;
    self.taskDifficultyTextField.enabled = true;
    self.prioritySegmentation.enabled = true;
    self.categorySegmentation.enabled = true;
    self.taskDescriptionTextField.enabled = true;
    self.taskMembersTextField.enabled = true;
    buttonMembersView.enabled = true;
    pickerStatus.userInteractionEnabled = true;
    stepperDuration.enabled = true;
    
    self.status = 0;
}


/**
 * Back to the previous view controller
**/
- (void) cancelButton:(id)sender {
    ScrumBoardScreenViewController* UserVc = [[ScrumBoardScreenViewController alloc] init];
    [self.navigationController pushViewController:UserVc animated:YES];
}

@end
