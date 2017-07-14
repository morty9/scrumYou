//
//  AddTaskScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AddTaskScreenViewController.h"
#import "ScrumBoardScreenViewController.h"
#import "APIKeys.h"
#import "CrudUsers.h"
#import "CrudTasks.h"

@interface AddTaskScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AddTaskScreenViewController {
    NSMutableArray<User*>* get_users;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResults;
    NSArray* statusArray;
    
    UIVisualEffectView *blurEffectView;
    
    NSString* statusTask;
    
    NSInteger priority;
    NSInteger nMember;
    NSInteger category;
    
    CrudUsers* Users;
    CrudTasks* Tasks;
}

@synthesize token_dic = _token_dic;
@synthesize id_task = _id_task;
@synthesize taskTitleTextField = _taskTitleTextField;
@synthesize taskDescriptionTextField = _taskDescriptionTextField;
@synthesize taskDifficultyTextField = _taskDifficultyTextField;
@synthesize taskCostTextField = _taskCostTextField;
@synthesize taskDurationTextField = _taskDurationTextField;
@synthesize taskMembersTextField = _taskMembersTextField;
@synthesize prioritySegmentation = _prioritySegmentation;
@synthesize categorySegmentation = _categorySegmentation;
@synthesize status = _status;
@synthesize mTask = _mTask;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self != nil) {
        
        self.status = false;
        statusTask = @"A faire";
        statusArray = @[@"A faire", @"En cours", @"Finies"];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self designPage];
    
    Users = [[CrudUsers alloc] init];
    [Users getUsers:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS GET USERS");
        }
    }];
    
    Tasks = [[CrudTasks alloc] init];
    
    get_users = [[NSMutableArray<User*> alloc] init];
    members = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    
    pickerStatus.delegate = self;
    pickerStatus.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    membersTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [membersTableView reloadData];
}

/**
 * Get users form database
**/
- (void) getUsername {
    get_users = Users.userList;
    [membersTableView reloadData];
}


/**
 * Add task to database
**/
- (IBAction)didTouchAddButton:(id)sender {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [Tasks addTaskTitle:self.taskTitleTextField.text description:self.taskDescriptionTextField.text difficulty:self.taskDifficultyTextField.text priority:[NSNumber numberWithInteger:priority] id_category:[NSNumber numberWithInteger:category] businessValue:self.taskCostTextField.text duration:self.taskDurationTextField.text status:statusTask id_members:ids callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD TASK");
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([Tasks.dict_error valueForKey:@"type"] != nil) {
                    NSString* title = [weakSelf->Tasks.dict_error valueForKey:@"title"];
                    NSString* message = [weakSelf->Tasks.dict_error valueForKey:@"message"];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Création réussie" message:@"Votre tâche a été créé." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        // GO TO SCRUM BOARD
                        ///////////////////////:
                        ///////////////////////
                        ///////////////////////
                        /////////////////////
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
            });
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return statusArray.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [statusArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        statusTask = @"Todo";
    }
    statusTask = [statusArray objectAtIndex:row];
}

- (IBAction)didTouchModifyButton:(id)sender {
    
    NSLog(@"STATUS %@", statusTask);
    
    [Tasks updateTaskId:[NSString stringWithFormat:@"%@", self.id_task] title:self.taskTitleTextField.text description:self.taskDescriptionTextField.text difficulty:self.taskDifficultyTextField.text priority:[NSNumber numberWithInteger:priority] id_category:[NSNumber numberWithInteger:category] businessValue:self.taskCostTextField.text duration:self.taskDurationTextField.text status:statusTask id_members:ids callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"UPDATE SUCCESS");
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
    [self getUsername];
    [membersView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:membersView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResults.count;
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
        username = [searchResults objectAtIndex:indexPath.row];
    }else {
        username = [get_users objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullname contains[c] %@ OR nickname contains[c] %@", searchText, searchText];
    searchResults = [get_users filteredArrayUsingPredicate:predicate];
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
    self.navigationItem.title = [NSString stringWithFormat:@"Ajouter une tâche"];
    
    if (self.status == false) {
        [buttonValidate setHidden:NO];
        [buttonModify setHidden:YES];
    } else {
        [buttonModify setHidden:NO];
        [buttonValidate setHidden:YES];
        
        NSLog(@"TASK %@", self.mTask.difficulty);
        
        self.navigationItem.title = [NSString stringWithFormat:@"Modifier une tâche"];
        
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
    
    UINavigationBar* bar = [self.navigationController navigationBar];
    [bar setHidden:false];
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //border taskTitle text field
    CALayer *borderTaskTitle = [CALayer layer];
    CGFloat borderWidthTaskTitle = 1;
    borderTaskTitle.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskTitle.frame = CGRectMake(0, self.taskTitleTextField.frame.size.height - borderWidthTaskTitle, self.taskTitleTextField.frame.size.width, self.taskTitleTextField.frame.size.height);
    borderTaskTitle.borderWidth = borderWidthTaskTitle;
    [self.taskTitleTextField.layer addSublayer:borderTaskTitle];
    self.taskTitleTextField.layer.masksToBounds = YES;
    
    //border taskDescription text field
    CALayer *borderTaskDescription = [CALayer layer];
    CGFloat borderWidthTaskDescription = 1;
    borderTaskDescription.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDescription.frame = CGRectMake(0, self.taskDescriptionTextField.frame.size.height - borderWidthTaskDescription, self.taskDescriptionTextField.frame.size.width, self.taskDescriptionTextField.frame.size.height);
    borderTaskDescription.borderWidth = borderWidthTaskDescription;
    [self.taskDescriptionTextField.layer addSublayer:borderTaskDescription];
    self.taskDescriptionTextField.layer.masksToBounds = YES;
    
    //border taskDifficulty text field
    CALayer *borderTaskDifficulty = [CALayer layer];
    CGFloat borderWidthTaskDifficulty = 1;
    borderTaskDifficulty.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDifficulty.frame = CGRectMake(0, self.taskDifficultyTextField.frame.size.height - borderWidthTaskDifficulty, self.taskDifficultyTextField.frame.size.width, self.taskDifficultyTextField.frame.size.height);
    borderTaskDifficulty.borderWidth = borderWidthTaskDifficulty;
    [self.taskDifficultyTextField.layer addSublayer:borderTaskDifficulty];
    self.taskDifficultyTextField.layer.masksToBounds = YES;
    
    //border taskCost text field
    CALayer *borderTaskCost = [CALayer layer];
    CGFloat borderWidthTaskCost = 1;
    borderTaskCost.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskCost.frame = CGRectMake(0, self.taskCostTextField.frame.size.height - borderWidthTaskCost, self.taskCostTextField.frame.size.width, self.taskCostTextField.frame.size.height);
    borderTaskCost.borderWidth = borderWidthTaskCost;
    [self.taskCostTextField.layer addSublayer:borderTaskCost];
    self.taskCostTextField.layer.masksToBounds = YES;
    
    //border radius member view
    membersView.layer.cornerRadius = 2.0;
    
}

/**
 * Back to the previous view controller
**/
- (void) cancelButton:(id)sender {
    ScrumBoardScreenViewController* UserVc = [[ScrumBoardScreenViewController alloc] init];
    [self.navigationController pushViewController:UserVc animated:YES];
}

@end
