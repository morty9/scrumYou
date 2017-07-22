//
//  ProjectSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ProjectSettingsScreenViewController.h"
#import "HomeScreenViewController.h"
#import "APIKeys.h"
#import "Project.h"
#import "Sprint.h"
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"
#import "UserHomeScreenViewController.h"

@interface ProjectSettingsScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>


@end

@implementation ProjectSettingsScreenViewController {
    
    NSMutableArray<User*>* get_users;
    NSMutableArray<User*>* users_in;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResults;
    
    NSDate* currentDate;
    NSDate* endDate;
    
    UserHomeScreenViewController* userHomeVC;
    
    UIVisualEffectView *blurEffectView;
    
    NSInteger nMember;
    NSInteger nMemberProject;
    NSString* idProject;
    
    CrudUsers* UsersCrud;
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    
    UIBarButtonItem* updateButtonEdit;
    UIBarButtonItem* updateButtonCancel;
    
    Sprint* newSprint;
    
    bool hasClickedOnModifyButton;
    
}

@synthesize token_dic = _token_dic;
@synthesize currentProject = _currentProject;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        get_users = [[NSMutableArray<User*> alloc] init];
        users_in = [[NSMutableArray<User*> alloc] init];
        members = [[NSMutableArray<User*> alloc] init];
        ids = [[NSMutableArray alloc] init];
        
        UsersCrud = [[CrudUsers alloc] init];
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        
        userHomeVC = [[UserHomeScreenViewController alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self designPage];
    
    hasClickedOnModifyButton = NO;
    nameTextField.enabled = false;
    membersCount.enabled = false;
    editButtonMembers.enabled = false;
    validateModification.hidden = true;
    
    updateButtonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(enableTextField:)];
    self.navigationItem.rightBarButtonItem = updateButtonEdit;
    updateButtonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(enableTextField:)];
    
    get_users = [[NSMutableArray<User*> alloc] init];
    users_in = [[NSMutableArray<User*> alloc] init];
    members = [[NSMutableArray<User*> alloc] init];
    ids = [[NSMutableArray alloc] init];
    
    nMember = 0;
    
    [UsersCrud getUsers:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS GET USERS");
        }
    }];
    
    [self displayTitleProject:self.currentProject];
    [self getUserByProject];
    
    [membersTableView reloadData];
}

/*
 *  VOID -> dipslay the title of the current project in the name text field
 */
- (void) displayTitleProject:(Project*)curProject {

    nameTextField.text = curProject.title;
    self.navigationItem.title = curProject.title;
}

/*
 *  VOID -> get all users link to the current project
 *  Call getUserById web service
 */
- (void) getUserByProject {
    
    for (NSNumber* membersArray in self.currentProject.id_members) {
        NSString* result = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@",[membersArray stringValue]]];
        [UsersCrud getUserById:result callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS USERS IN");
                [users_in addObject:UsersCrud.user];
                nMemberProject = users_in.count;
                membersCount.text = [@(nMemberProject)stringValue];
            }
            [membersTableView reloadData];
        }];
    }
}


/*
 *  IBAction -> button "+" show members windows
 */
- (IBAction)showAddMembersView:(id)sender {
    [self getUsername];
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
    get_users = UsersCrud.userList;
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
 *  IBAction -> button "Validate"
 *  Update members label
 **/
- (IBAction)validateMembers:(id)sender {
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
 *  IBAction -> Close members windows
 **/
- (IBAction)closeWindowMembers:(id)sender {
    [membersView setHidden:true];
    [blurEffectView removeFromSuperview];
    if(self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
}

// Modify a project

- (void) enableTextField:(id)sender {
    if (hasClickedOnModifyButton == NO) {
        validateModification.hidden = false;
        nameTextField.enabled = true;
        nameTextField.textColor = [UIColor lightGrayColor];
        membersCount.textColor = [UIColor lightGrayColor];
        editButtonMembers.enabled = true;
        
        hasClickedOnModifyButton = YES;
        self.navigationItem.rightBarButtonItem = updateButtonCancel;
        
    } else {
        NSLog(@"USERS IN %@", users_in);
        validateModification.hidden = true;
        nameTextField.enabled = false;
        nameTextField.textColor = [UIColor blackColor];
        nameTextField.text = self.currentProject.title;
        membersCount.text = [@(nMemberProject)stringValue];
        membersCount.textColor = [UIColor blackColor];
        editButtonMembers.enabled = false;
        
        
        hasClickedOnModifyButton = NO;
        self.navigationItem.rightBarButtonItem = updateButtonEdit;
        
    }
    
}

/**
 *  IBAction -> Update project in database
 *  Call updateProject web service
 **/
- (IBAction)validationModification:(id)sender {
    if (ids.count == 0) {
        for (NSString* usr in users_in) {
            [ids addObject:[usr valueForKey:@"id_user"]];
        }
    }
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [NSDate date];
    endDate = [sprintEndDate date];
    NSString* end_dateString = [formatter stringFromDate:endDate];
    NSString* current_dateString = [formatter stringFromDate:currentDate];
    NSString* token = [self.token_dic valueForKey:@"token"];
    
    
    if ([sprintNameTextField.text  isEqual:@""] || ([sprintEndDate date] == currentDate)) {
        [weakSelf updateProject];
    } else {
        [SprintsCrud addSprintTitle:sprintNameTextField.text beginningDate:current_dateString endDate:end_dateString token:token callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS ADD SPRINT");
                newSprint = SprintsCrud.sprint;
                [weakSelf updateProject];
            }
        }];
    }
    
}

- (IBAction)projectFinished:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSString* token = [self.token_dic valueForKey:@"token"];
    NSMutableArray* id_sprints = [weakSelf addSprintToCurrentProject];
    
    [weakSelf->ProjectsCrud updateProjectId:[NSString stringWithFormat:@"%@",weakSelf.currentProject.id_project] title:nameTextField.text id_creator:weakSelf.currentProject.id_creator members:weakSelf.currentProject.id_members token:token id_sprints:id_sprints status:YES callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD PROJECT");
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([ProjectsCrud.dict_error valueForKey:@"type"] != nil) {
                    NSString* title = [weakSelf->ProjectsCrud.dict_error valueForKey:@"title"];
                    NSString* message = [weakSelf->ProjectsCrud.dict_error valueForKey:@"message"];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Projet terminé" message:@"Votre projet a été placé dans les projets terminés avec succès." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        userHomeVC = [[UserHomeScreenViewController alloc] init];
                        weakSelf->userHomeVC.token = weakSelf.token_dic;
                        [weakSelf.navigationController pushViewController:weakSelf->userHomeVC animated:YES];
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
            });
        }
    }];

}

- (void) updateProject {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSString* token = [self.token_dic valueForKey:@"token"];
    NSMutableArray* id_sprints = [weakSelf addSprintToCurrentProject];
    
    [weakSelf->ProjectsCrud updateProjectId:[NSString stringWithFormat:@"%@",weakSelf.currentProject.id_project] title:nameTextField.text id_creator:weakSelf.currentProject.id_creator members:weakSelf->ids token:token id_sprints:id_sprints status:NO callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD PROJECT");
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([ProjectsCrud.dict_error valueForKey:@"type"] != nil) {
                    NSString* title = [weakSelf->ProjectsCrud.dict_error valueForKey:@"title"];
                    NSString* message = [weakSelf->ProjectsCrud.dict_error valueForKey:@"message"];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Modification réussie" message:@"Votre projet a été modifié avec succès." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        userHomeVC = [[UserHomeScreenViewController alloc] init];
                        weakSelf->userHomeVC.token = weakSelf.token_dic;
                        [weakSelf.navigationController pushViewController:weakSelf->userHomeVC animated:YES];
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
            });
        }
    }];

    
}

- (NSMutableArray*) addSprintToCurrentProject {
    
    NSMutableArray* list_sprints = [NSMutableArray new];
    
    if (![self.currentProject.id_sprints isKindOfClass:[NSNull class]]) {
        list_sprints = [[NSMutableArray alloc] initWithArray:self.currentProject.id_sprints];
    }
    
    if (newSprint.id_sprint != nil) {
        [list_sprints addObject:newSprint.id_sprint];
    }
    
    return list_sprints;
}


- (IBAction)deleteProject:(id)sender {
 
 
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation supression" message:@"Êtes-vous sûr de vouloir supprimer ce projet ?" preferredStyle: UIAlertControllerStyleAlert];
        
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [ProjectsCrud deleteProjectWithId:[NSString stringWithFormat:@"%@", self.currentProject.id_project] token:[self.token_dic valueForKey:@"token"] callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS DELETE");
                //TODO!!!!!!!!!!!!!!!!!!!!!
                NSLog(@"RETURN TO HOME USER SCREEN");
            }
        }];
    }];
        
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
        
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void) designPage {
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

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
    
    //border sprintName text field
    CALayer *borderSprintName = [CALayer layer];
    CGFloat borderWidthSprintName = 1.5;
    borderSprintName.borderColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0].CGColor;
    borderSprintName.frame = CGRectMake(0, sprintNameTextField.frame.size.height - borderWidthSprintName, sprintNameTextField.frame.size.width, sprintNameTextField.frame.size.height);
    borderSprintName.borderWidth = borderWidthSprintName;
    [sprintNameTextField.layer addSublayer:borderSprintName];
    sprintNameTextField.layer.masksToBounds = YES;
    
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
