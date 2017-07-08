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
#import "AddTask.h"

@interface AddTaskScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

@implementation AddTaskScreenViewController {
    NSMutableArray<User*>* get_users;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResults;
    
    UIVisualEffectView *blurEffectView;
    
    NSInteger priority;
    NSInteger nMember;
    NSInteger category;
    
    CrudUsers* Users;
    AddTask* Tasks;
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
    
    Tasks = [[AddTask alloc] init];
    
    get_users = [[NSMutableArray<User*> alloc] init];
    members = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    
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
    
    [Tasks addTaskTitle:taskTitleTextField.text description:taskDescriptionTextField.text difficulty:taskDifficultyTextField.text priority:[NSNumber numberWithInteger:priority] id_category:[NSNumber numberWithInteger:category] color:buttonColorView.restorationIdentifier businessValue:taskCostTextField.text duration:taskDurationTextField.text id_members:ids];
    
    taskTitleTextField.text = @"";
    taskDescriptionTextField.text = @"";
    taskDifficultyTextField.text = @"";
    taskMembersTextField.text = @"";
    taskCostTextField.text = @"";
    taskDurationTextField.text = @"";
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
    taskMembersTextField.text = [@(nMember)stringValue];
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
    taskDurationTextField.text = [NSString stringWithFormat:@"%02lu", (unsigned long)value];
}


/**
 * Diplaying window color
**/
- (IBAction)showWindowColor:(id)sender {
    [colorView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:colorView];
}

/**
 * BUTTON VIEW COLOR
**/

/**
 * Choose red button
**/
- (IBAction)redButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = redColor.backgroundColor;
    buttonColorView.restorationIdentifier = redColor.restorationIdentifier;
}

/**
 * Choose blue button
**/
- (IBAction)blueButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = blueColor.backgroundColor;
    buttonColorView.restorationIdentifier = blueColor.restorationIdentifier;
}

/**
 * Choose orange button
 **/
- (IBAction)orangeButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = orangeColor.backgroundColor;
    buttonColorView.restorationIdentifier = orangeColor.restorationIdentifier;
}

/**
 * Choose green button
 **/
- (IBAction)greenButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = greenColor.backgroundColor;
    buttonColorView.restorationIdentifier = greenColor.restorationIdentifier;
}

/**
 * Choose purple button
 **/
- (IBAction)purpleButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = purpleColor.backgroundColor;
    buttonColorView.restorationIdentifier = purpleColor.restorationIdentifier;
}

/**
 * Choose yellow button
 **/
- (IBAction)yellowButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = yellowColor.backgroundColor;
    buttonColorView.restorationIdentifier = yellowColor.restorationIdentifier;
}

/**
 * Choose darkBlue button
 **/
- (IBAction)darkBlueButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = darkBlueColor.backgroundColor;
    buttonColorView.restorationIdentifier = darkBlueColor.restorationIdentifier;
}

/**
 * Choose pink button
 **/
- (IBAction)pinkButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = pinkColor.backgroundColor;
    buttonColorView.restorationIdentifier = pinkColor.restorationIdentifier;
}

/**
 * Choose gray button
 **/
- (IBAction)grayBlueButtonChoosen:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
    buttonColorView.backgroundColor = grayBlueColor.backgroundColor;
    buttonColorView.restorationIdentifier = grayBlueColor.restorationIdentifier;
}

/**
 * Close window Color
 **/
- (IBAction)closeWindowColor:(id)sender {
    [colorView setHidden:true];
    [blurEffectView removeFromSuperview];
}

/**
 * Design the page
**/
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
    
    //border taskDifficulty text field
    CALayer *borderTaskDifficulty = [CALayer layer];
    CGFloat borderWidthTaskDifficulty = 1;
    borderTaskDifficulty.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskDifficulty.frame = CGRectMake(0, taskDifficultyTextField.frame.size.height - borderWidthTaskDifficulty, taskDifficultyTextField.frame.size.width, taskDifficultyTextField.frame.size.height);
    borderTaskDifficulty.borderWidth = borderWidthTaskDifficulty;
    [taskDifficultyTextField.layer addSublayer:borderTaskDifficulty];
    taskDifficultyTextField.layer.masksToBounds = YES;
    
    //border taskCost text field
    CALayer *borderTaskCost = [CALayer layer];
    CGFloat borderWidthTaskCost = 1;
    borderTaskCost.borderColor = [UIColor darkGrayColor].CGColor;
    borderTaskCost.frame = CGRectMake(0, taskCostTextField.frame.size.height - borderWidthTaskCost, taskCostTextField.frame.size.width, taskCostTextField.frame.size.height);
    borderTaskCost.borderWidth = borderWidthTaskCost;
    [taskCostTextField.layer addSublayer:borderTaskCost];
    taskCostTextField.layer.masksToBounds = YES;
    
    //border radius color view
    colorView.layer.cornerRadius = 2.0;
    
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
