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
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"

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
    
    UIVisualEffectView *blurEffectView;
    
    NSInteger nMember;
    NSInteger nMemberProject;
    NSString* idProject;
    
    CrudUsers* UsersCrud;
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    
    UIBarButtonItem* updateButtonEdit;
    UIBarButtonItem* updateButtonCancel;
    
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
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self designPage];
    
    hasClickedOnModifyButton = NO;
    
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

- (IBAction)addSprint:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [NSDate date];
    endDate = [sprintEndDate date];
    NSString* end_dateString = [formatter stringFromDate:endDate];
    NSString* current_dateString = [formatter stringFromDate:currentDate];

    
    [SprintsCrud addSprintTitle:sprintNameTextField.text beginningDate:current_dateString endDate:end_dateString callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD SPRINT");
        }
    }];
    
    sprintNameTextField.text = @"";
    endDate = currentDate;
}



// Modify a project

- (void) enableTextField:(id)sender {
    if (hasClickedOnModifyButton == NO) {
        hasClickedOnModifyButton = YES;
        validateButton.hidden = false;
        nameTextField.enabled = true;
        nameTextField.textColor = [UIColor lightGrayColor];
        
        self.navigationItem.rightBarButtonItem = updateButtonCancel;
        
    } else {
        hasClickedOnModifyButton = NO;
        validateButton.hidden = true;
        nameTextField.enabled = false;
        nameTextField.textColor = [UIColor blackColor];
        nameTextField.text = self.currentProject.title;
        
        self.navigationItem.rightBarButtonItem = updateButtonEdit;
        
    }
    
}

/**
 *  IBAction -> Update project in database
 *  Call updateProject web service
 **/
/*- (IBAction)validationModification:(id)sender {
    if (ids.count == 0) {
        for (NSString* usr in users_in) {
            [ids addObject:[usr valueForKey:@"id_user"]];
        }
    }
    [ProjectsCrud updateProjectId:idProject title:nameTextField.text members:ids token:[self.token_dic valueForKey:@"token"] callback:^(NSError *error, BOOL success) {
        NSLog(@"SUCCESS UPDATE");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Modification terminée"message:@"Les modifications de votre projet ont été prises en compte." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self viewDidLoad];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        });
    }];
}
- (IBAction)deleteProject:(id)sender {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation supression" message:@"Êtes-vous sûr de vouloir supprimer ce projet ?" preferredStyle: UIAlertControllerStyleAlert];
        
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [ProjectsCrud deleteProjectWithId:idProject token:[self.token_dic valueForKey:@"token"] callback:^(NSError *error, BOOL success) {
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
}*/


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
