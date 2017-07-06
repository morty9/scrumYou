//
//  ProjectSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ProjectSettingsScreenViewController.h"
#import "APIKeys.h"
#import "GetProjectsById.h"
#import "Project.h"
#import "GetUserById.h"
#import "GetUsers.h"
#import "UpdateProjects.h"

@interface ProjectSettingsScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

- (void) editProject;

- (void) editMembers;

- (void) cancelButton;

@end

@implementation ProjectSettingsScreenViewController {
    
    NSMutableArray<Project*>* projects;
    
    NSMutableArray<User*>* get_users;
    NSMutableArray<User*>* users_in;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResults;
    
    UIVisualEffectView *blurEffectView;
    
    NSInteger nMember;
    NSInteger nMemberProject;
    
    GetProjectsById* Projects;
    GetUserById* UsersIn;
    GetUsers* Users;
    UpdateProjects* Update;
    
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        projects = [[NSMutableArray<Project*> alloc] init];
        get_users = [[NSMutableArray<User*> alloc] init];
        users_in = [[NSMutableArray<User*> alloc] init];
        members = [[NSMutableArray<User*> alloc] init];
        ids = [[NSMutableArray alloc] init];
        
        Projects = [[GetProjectsById alloc] init];
        UsersIn = [[GetUserById alloc] init];
        Users = [[GetUsers alloc] init];
        Update = [[UpdateProjects alloc] init];
        
        [Users getUsers];
        
        [Projects getProjectById:@"/1" callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS PROJECT");
                projects = Projects.projects_list;
                NSLog(@"p %@", projects);
                [self displayTitleProject];
                [self getUserByProject];
            }
        }];
        
        [membersTableView reloadData];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self designPage];
    
    [membersTableView reloadData];
}


- (void) displayTitleProject {
    
    NSLog(@"%@", projects);

    for (NSString* p in projects) {
        nameTextField.text = [p valueForKey:@"_title"];
        self.navigationItem.title = [p valueForKey:@"_title"];
    }
}

- (void) getUserByProject {
    
    NSLog(@"project %@", projects);
    
    for (NSMutableArray* membersArray in [projects valueForKey:@"_id_members"]) {
        for (NSString* m in membersArray) {
            NSString* result = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@",m]];
            [UsersIn getUserById:result callback:^(NSError *error, BOOL success) {
                if (success) {
                    NSLog(@"SUCCESS USERS IN");
                    users_in = UsersIn.usersList;
                    nMemberProject = users_in.count;
                    membersCount.text = [@(nMemberProject)stringValue];
                }
                [membersTableView reloadData];
            }];
        }
    }
}

- (IBAction)showAddMembersView:(id)sender {
    [self getUsername];
    [membersView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:membersView];
}

/**
 * Get users form database
 **/
- (void) getUsername {
    get_users = Users.users_list;
    [membersTableView reloadData];
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
    
    for (User* user in users_in) {
        if ([user.fullname isEqualToString:[get_users objectAtIndex:indexPath.row].fullname]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            nMember+=1;
            [members addObject:user.fullname];
            NSLog(@"M %@", members);
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
        }

    }

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
    NSLog(@"members %@", members);
    [membersView setHidden:true];
    [blurEffectView removeFromSuperview];
    membersCount.text = [@(nMember)stringValue];
    if(self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
    [self getIdUser];
    [users_in removeAllObjects];
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
 * Update project to database
 **/
- (IBAction)validationModification:(id)sender {
    if (ids.count == 0) {
        for (NSString* usr in users_in) {
            [ids addObject:[usr valueForKey:@"id_user"]];
        }
    }
    NSLog(@"ids %@", ids);
    [Update updateProjectTitle:nameTextField.text members:ids];
}

- (IBAction)deleteProject:(id)sender {
}


- (void) cancelButton {
    
}

- (void) designPage {
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    //border name project text field
    CALayer *borderName = [CALayer layer];
    CGFloat borderWidthName = 1.5;
    borderName.borderColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0].CGColor;
    borderName.frame = CGRectMake(0, nameTextField.frame.size.height - borderWidthName, nameTextField.frame.size.width, nameTextField.frame.size.height);
    borderName.borderWidth = borderWidthName;
    [nameTextField.layer addSublayer:borderName];
    nameTextField.layer.masksToBounds = YES;
    
    //border name members text field title
    CALayer *borderMembers = [CALayer layer];
    CGFloat borderWidthMembers = 1.5;
    borderMembers.borderColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0].CGColor;
    borderMembers.frame = CGRectMake(0, membersTextField.frame.size.height - borderWidthMembers, membersTextField.frame.size.width, membersTextField.frame.size.height);
    borderMembers.borderWidth = borderWidthMembers;
    [membersTextField.layer addSublayer:borderMembers];
    membersTextField.layer.masksToBounds = YES;
    
    //border name members text field number
    CALayer *borderMembersNumber = [CALayer layer];
    CGFloat borderWidthMembersNumber = 1.5;
    borderMembersNumber.borderColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0].CGColor;
    borderMembersNumber.frame = CGRectMake(0, membersCount.frame.size.height - borderWidthMembersNumber, membersCount.frame.size.width, membersCount.frame.size.height);
    borderMembersNumber.borderWidth = borderWidthMembersNumber;
    [membersCount.layer addSublayer:borderMembersNumber];
    membersCount.layer.masksToBounds = YES;
    
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
