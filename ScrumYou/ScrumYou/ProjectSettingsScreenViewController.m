//
//  ProjectSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ProjectSettingsScreenViewController.h"
#import "HomeScreenViewController.h"
#import "ErrorsViewController.h"
#import "APIKeys.h"
#import "Project.h"
#import "Sprint.h"
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"
#import "UserHomeScreenViewController.h"
#import "ScrumBoardScreenViewController.h"

@interface ProjectSettingsScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UITextFieldDelegate>


@end

@implementation ProjectSettingsScreenViewController {
    
    NSMutableArray<User*>* get_users;
    NSMutableArray<User*>* users_in;
    NSMutableArray<Sprint*>* get_sprints;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResultsUsers;
    NSArray* searchResultsSprints;
    
    NSDate* currentDate;
    NSDate* endDate;
    
    UserHomeScreenViewController* userHomeVC;
    ProjectSettingsScreenViewController* projectSettingsVC;
    ErrorsViewController* errors;
    ScrumBoardScreenViewController* scrumBoardVC;
    
    UIVisualEffectView *blurEffectView;
    
    NSInteger nMember;
    NSInteger nMemberProject;
    
    NSString* idProject;
    NSString* token;
    
    CrudUsers* UsersCrud;
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    
    UIBarButtonItem* updateButtonEdit;
    UIBarButtonItem* updateButtonCancel;
    
    Sprint* newSprint;
    Sprint* sprintSelected;
    
    bool hasClickedOnModifyButton;
    bool toAdd;
    
}

@synthesize token_dic = _token_dic;
@synthesize currentProject = _currentProject;
@synthesize isComeToSB = _isComeToSB;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        get_users = [[NSMutableArray<User*> alloc] init];
        users_in = [[NSMutableArray<User*> alloc] init];
        members = [[NSMutableArray<User*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        ids = [[NSMutableArray alloc] init];
        
        UsersCrud = [[CrudUsers alloc] init];
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        
        userHomeVC = [[UserHomeScreenViewController alloc] init];
        errors = [[ErrorsViewController alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    sprintsTableView.delegate = self;
    sprintsTableView.dataSource = self;
    
    nameTextField.delegate = self;
    sprintNameTextField.delegate = self;
    
    [self designPage];
    
    token = [self.token_dic valueForKey:@"token"];
    nMember = 0;
    toAdd = false;
    self.isComeToSB = false;
    
    [self getProjectById];
    [self getUsers];
    [self displayTitleProject:self.currentProject];
    [self getSprintByProject];
    [self getUserByProject];
    
    [membersTableView reloadData];
    [sprintsTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

/*
 *  VOID -> Get project by current id
 *  Call GetProjectById web services
 */
- (void) getProjectById {
    
    [ProjectsCrud getProjectById:[NSString stringWithFormat:@"%@", self.currentProject.id_project] callback:^(NSError *error, BOOL success) {
        if (success) {
            self.currentProject = ProjectsCrud.project;
        }
    }];
    
}

/*
 *  VOID -> get all users from database
 *  Call GetUsers web service
 */
- (void) getUsers {
    [UsersCrud getUsers:^(NSError *error, BOOL success) {
        if (success) {}
    }];
}

/*
 *  VOID -> dipslay the title of the current project in the name text field
 */
- (void) displayTitleProject:(Project*)curProject {
    nameTextField.text = curProject.title;
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
                [users_in addObject:UsersCrud.user];
                nMemberProject = users_in.count;
                membersCount.text = [@(nMemberProject)stringValue];
            }
            [membersTableView reloadData];
        }];
    }
}

/**
 *  VOID -> Get all sprints by project
 *  Call GetSprintById web service
 **/
- (void) getSprintByProject {
    for (NSNumber* sprints in self.currentProject.id_sprints) {
        NSString* result = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@",[sprints stringValue]]];
        [SprintsCrud getSprintById:result callback:^(NSError *error, BOOL success) {
            if (success) {
                [get_sprints addObject:SprintsCrud.sprint];
            }
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

/**
 *  NSInteger -> Return number of data in arrays
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive || self.searchControllerSprints.isActive) {
        if (tableView == membersTableView) {
            return [searchResultsUsers count];
        } else {
            return [searchResultsSprints count];
        }
    }else {
        if (tableView == membersTableView) {
            return [get_users count];
        } else {
            return [get_sprints count];
        }
    }
}

/**
 *  UITableViewCell-> Put current data in a cell
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* const kCellId = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    User* username;
    Sprint* sprint;
    if(self.searchController.isActive || self.searchControllerSprints.isActive) {
        if (tableView == membersTableView) {
            username = [searchResultsUsers objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
        } else {
            sprint = [searchResultsSprints objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", sprint.title];
        }
        
    }else {
        if (tableView == membersTableView) {
            username = [get_users objectAtIndex:indexPath.row];
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
        } else {
            sprint = [get_sprints objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", sprint.title];
        }
        
    }

    return cell;
}

/**
 *  VOID -> Allow to add a member to a project or show details of a selected sprint
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [membersTableView cellForRowAtIndexPath:indexPath];

    if (tableView == membersTableView) {
        if (cell.accessoryType) {
            cell.accessoryType = NO;
            [members removeObject:cell.textLabel.text];
            nMember-=1;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [members addObject:cell.textLabel.text];
            nMember+=1;
        }

    } else {
        sprintSelected = [get_sprints objectAtIndex:indexPath.row];
        [self modifySprint];
        sprintNameTextField.text = sprintSelected.title;
    }
}

/**
 *  VOID -> Allow to call delete sprint web service when user slide left a row in the table view
 **/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Sprint* removedSprint = [get_sprints objectAtIndex:indexPath.row];
        
        [SprintsCrud deleteSprintWithId:[NSString stringWithFormat:@"%@", removedSprint.id_sprint] id_project:[NSString stringWithFormat:@"%@", self.currentProject.id_project] token:token callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SPRINT REMOVED SUCCESS");
            }
        }];
        
        [get_sprints removeObjectAtIndex:indexPath.row];
        [sprintsTableView reloadData];
    }
}

/**
 *  BOOL -> Allow to activate edition of row in the table view
 **/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    
    if(searchController == self.searchController) {
        [self searchForTextUsers:searchString];
        [membersTableView reloadData];
    } else {
        [self searchForTextSprints:searchString];
        [sprintsTableView reloadData];
    }
}

- (void)searchForTextUsers:(NSString*)searchText {
    NSPredicate *predicateUsers = [NSPredicate predicateWithFormat:@"fullname contains[c] %@ OR nickname contains[c] %@", searchText, searchText];
    searchResultsUsers = [get_users filteredArrayUsingPredicate:predicateUsers];
}

- (void)searchForTextSprints:(NSString*)searchText {
    NSPredicate *predicateSprints = [NSPredicate predicateWithFormat:@"_title contains[c] %@", searchText];
    searchResultsSprints = [get_sprints filteredArrayUsingPredicate:predicateSprints];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
    [self updateSearchResultsForSearchController:self.searchControllerSprints];
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


/**
 *  VOID -> Enable or disable component when user click on modify button
 **/
- (void) enableTextField:(id)sender {
    if (hasClickedOnModifyButton == NO) {
        validateModification.hidden = false;
        nameTextField.enabled = true;
        nameTextField.textColor = [UIColor lightGrayColor];
        membersCount.textColor = [UIColor lightGrayColor];
        editButtonMembers.enabled = true;
        editButtonMembers.enabled = true;
        addSprint.enabled = true;
        sprintsTableView.allowsSelection = true;
        
        hasClickedOnModifyButton = YES;
        self.navigationItem.rightBarButtonItem = updateButtonCancel;
        
    } else {
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


/*
 *  SPRINTS VIEW
 */

/**
 *  VOID -> Show sprint view when user select a row in table view
 **/
- (void)modifySprint {
    [self getUsername];
    [sprintsView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffectView belowSubview:sprintsView];
}

/**
 *  IBAction -> Show sprint view when user want to add a sprint
 **/
- (IBAction)addSprint:(id)sender {
    toAdd = true;
    [self getUsername];
    [sprintsView setHidden:false];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    
    if (self.searchControllerSprints.isActive) {
        [self.searchControllerSprints setActive:NO];
    }
    
    [self.view insertSubview:blurEffectView belowSubview:sprintsView];
}


/**
 *  VOID -> Hide sprint view when user click on cross
 **/
- (void) hideSprintView {
    [get_sprints removeAllObjects];
    [self getSprintByProject];
    [sprintsView setHidden:true];
    [blurEffectView removeFromSuperview];
    [sprintsTableView reloadData];
}

/**
 *  VOID -> Validation of update sprint action
 *  Call update sprint web service
 **/
- (void) validModifSprint {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [NSDate date];
    endDate = [sprintEndDate date];
    NSString* end_dateString = [formatter stringFromDate:endDate];
    
    [SprintsCrud updateSprintId:[NSString stringWithFormat:@"%@", sprintSelected.id_sprint] title:sprintNameTextField.text beginningDate:sprintSelected.beginningDate endDate:end_dateString id_listTasks:sprintSelected.id_listTasks token:token callback:^(NSError *error, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sprint mis à jour" message:@"Votre sprint a été mis à jour avec succès." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self hideSprintView];
                }];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    
    toAdd = false;
}


/**
 *  VOID -> Validation of add sprint action
 *  Call Add Sprint web services
 **/
- (void) validAddSprint {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    if (ids.count == 0) {
        for (NSString* usr in users_in) {
            [ids addObject:[usr valueForKey:@"id_user"]];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [NSDate date];
    endDate = [sprintEndDate date];
    NSString* end_dateString = [formatter stringFromDate:endDate];
    NSString* current_dateString = [formatter stringFromDate:currentDate];
    
    if ([sprintNameTextField.text  isEqual:@""] || ([sprintEndDate date] == currentDate)) {
        [self updateProject];
    } else {
        [SprintsCrud addSprintTitle:sprintNameTextField.text beginningDate:current_dateString endDate:end_dateString token:token callback:^(NSError *error, BOOL success) {
            if (success) {
                newSprint = SprintsCrud.sprint;
                NSMutableArray* id_sprints = [weakSelf addSprintToCurrentProject];
                
                if (ids.count == 0) {
                    ids = weakSelf.currentProject.id_members;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf->ProjectsCrud updateProjectId:[NSString stringWithFormat:@"%@",weakSelf.currentProject.id_project] title:weakSelf->nameTextField.text id_creator:weakSelf.currentProject.id_creator members:weakSelf->ids token:weakSelf->token id_sprints:id_sprints status:NO callback:^(NSError *error, BOOL success) {
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf viewDidLoad];
                                weakSelf->sprintNameTextField.text = @"";
                                [weakSelf hideSprintView];
                            });
                        }
                    }];
                });
            }
        }];
    }
}

/**
 *  IBAction -> Validate sprint view
 *  Call method for add or update a sprint
 **/
- (IBAction)validationSprintView {
    if (toAdd == true) {
        [self validAddSprint];
    } else {
        [self validModifSprint];
    }
}


/**
 *  IBAction -> Close sprint view
 **/
- (IBAction)closeSprintView:(id)sender {
    [sprintsView setHidden:true];
    [blurEffectView removeFromSuperview];
    if(self.searchController.isActive) {
        [self.searchController setActive:NO];
    }
}


/**
 *  IBAction -> Add sprints in database
 *  Call AddSprint web service
 **/
- (IBAction)finalValidation:(id)sender {
    [self updateProject];
}


/**
 *  IBAction -> Update project at finished status
 *  Call Update Project web services
 **/
- (IBAction)projectFinished:(id)sender {
    
    [ProjectsCrud updateProjectId:[NSString stringWithFormat:@"%@",self.currentProject.id_project] title:nameTextField.text id_creator:self.currentProject.id_creator members:self.currentProject.id_members token:token id_sprints:self.currentProject.id_sprints status:YES callback:^(NSError *error, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([ProjectsCrud.dict_error valueForKey:@"type"] != nil) {
                    
                    [errors bddErrorsTitle:[ProjectsCrud.dict_error valueForKey:@"title"] message:[ProjectsCrud.dict_error valueForKey:@"message"] viewController:self];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Projet terminé" message:@"Votre projet a été placé dans les projets terminés avec succès." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        userHomeVC = [[UserHomeScreenViewController alloc] init];
                        self->userHomeVC.token = self.token_dic;
                        [self.navigationController pushViewController:userHomeVC animated:YES];
                    }];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }
    }];
}


/**
 *  VOID -> Update project
 *  Call Update Project web services
 **/
- (void) updateProject {
    
    if (ids.count == 0) {
        ids = self.currentProject.id_members;
    }
    
    [ProjectsCrud updateProjectId:[NSString stringWithFormat:@"%@",self.currentProject.id_project] title:nameTextField.text id_creator:self.currentProject.id_creator members:ids token:token id_sprints:self.currentProject.id_sprints status:NO callback:^(NSError *error, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([ProjectsCrud.dict_error valueForKey:@"type"] != nil) {

                    [errors bddErrorsTitle:[ProjectsCrud.dict_error valueForKey:@"title"] message:[ProjectsCrud.dict_error valueForKey:@"title"] viewController:self];
                    
                } else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Modification réussie" message:@"Votre projet a été modifié avec succès." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        userHomeVC = [[UserHomeScreenViewController alloc] init];
                        userHomeVC.token = self.token_dic;
                        [self.navigationController pushViewController:userHomeVC animated:YES];
                    }];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }
    }];
}

/**
 *  NSMutableArray -> add new sprint at current project array id_sprints
 **/
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

/**
 *  IBAction -> Delete project
 *  Call Delete Project web services
 **/
- (IBAction)deleteProject:(id)sender {
 
 
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation suppression" message:@"Êtes-vous sûr de vouloir supprimer ce projet ?" preferredStyle: UIAlertControllerStyleAlert];
        
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [ProjectsCrud deleteProjectWithId:[NSString stringWithFormat:@"%@", self.currentProject.id_project] token:[self.token_dic valueForKey:@"token"] callback:^(NSError *error, BOOL success) {
            if (success) {
                userHomeVC = [[UserHomeScreenViewController alloc] init];
                userHomeVC.token = self.token_dic;
                [self.navigationController pushViewController:userHomeVC animated:YES];
            }
        }];
    }];
        
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  VOID -> Back to user home screen view controller
 **/
- (void) backToUserHome {
    userHomeVC = [[UserHomeScreenViewController alloc] init];
    userHomeVC.token = self.token_dic;
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

- (void) backToScrumBoard {
    scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
    scrumBoardVC.token = self.token_dic;
    scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", self.currentProject.id_project];
    [self.navigationController pushViewController:scrumBoardVC animated:YES];
}

/**
 *  VOID -> Design component of view controller
 **/
- (void) designPage {
    
    self.navigationItem.title = @"Paramètres";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    updateButtonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(enableTextField:)];
    self.navigationItem.rightBarButtonItem = updateButtonEdit;
    updateButtonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(enableTextField:)];
    
    UIImage *backFromModify = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:backFromModify style:UIBarButtonItemStylePlain target:self action:@selector(backToScrumBoard)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    membersTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.searchControllerSprints = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchControllerSprints.searchResultsUpdater = self;
    self.searchControllerSprints.dimsBackgroundDuringPresentation = NO;
    self.searchControllerSprints.searchBar.delegate = self;
    self.searchControllerSprints.hidesNavigationBarDuringPresentation = NO;
    sprintsTableView.tableHeaderView = self.searchControllerSprints.searchBar;
    self.definesPresentationContext = YES;
    [self.searchControllerSprints.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchControllerSprints.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    editButtonMembers.enabled = false;
    sprintsTableView.allowsSelection = false;
    hasClickedOnModifyButton = false;
    nameTextField.enabled = false;
    membersCount.enabled = false;
    validateModification.hidden = true;
    addSprint.enabled = false;
    sprintsTableView.allowsSelection = false;
    
    if (self.isComeToSB == true) {
        UIImage *backFromModify = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:backFromModify style:UIBarButtonItemStylePlain target:self action:@selector(backToUserHome)];
        self.navigationItem.leftBarButtonItem = newBackButton;
        self.isComeToSB = false;
    }
    
    //disable past date in UIDatePicker
    sprintEndDate.minimumDate = [NSDate date];
    
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


@end
