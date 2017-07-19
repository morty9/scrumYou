//
//  AddProjectScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AddProjectScreenViewController.h"
#import "UserHomeScreenViewController.h"
#import "ScrumBoardScreenViewController.h"
#import "LoginScreenViewController.h"
#import "APIKeys.h"
#import "User.h"
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"
#import "CrudAuth.h"

@interface AddProjectScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

@implementation AddProjectScreenViewController {
    NSMutableArray<User*>* get_users;
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSInteger nMember;
    
    NSDate *currentDate;
    NSDate *endDate;
    
    NSArray* searchResults;
    
    UIVisualEffectView *blurEffectView;
    
    NSDictionary* auth;

    CrudUsers* Users;
    CrudProjects* Projects;
    CrudSprints* Sprints;
    
    UserHomeScreenViewController* userHomeVC;
}

@synthesize token_dic = _token_dic;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    NSLog(@"TOKEN ADD PROJECT %@", _token_dic);
    
    [self designPage];
    
    Users = [[CrudUsers alloc] init];
    [Users getUsers:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS GET USERS");
        }
    }];
    
    Projects = [[CrudProjects alloc] init];
    Sprints = [[CrudSprints alloc] init];
    
    get_users = [[NSMutableArray<User*> alloc] init];
    members = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    auth = [[NSDictionary alloc] init];
    
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
 * Add project to database and clear textfield content
**/
- (IBAction)didTouchAddButton:(id)sender {
    
    NSLog(@"token %@", _token_dic);
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [NSDate date];
    endDate = [sprintEndDate date];
    NSString* end_dateString = [formatter stringFromDate:endDate];
    NSString* current_dateString = [formatter stringFromDate:currentDate];
    
    [Sprints addSprintTitle:sprintNameTextField.text beginningDate:current_dateString endDate:end_dateString callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD SPRINT");
            NSMutableArray* sprints = [[NSMutableArray alloc] init];
            [sprints addObject:weakSelf->Sprints.sprint.id_sprint];
            
            [weakSelf->Projects addProjecTitle:weakSelf->projectNameTextField.text members:weakSelf->ids sprints:sprints id_creator:[weakSelf.token_dic valueForKey:@"userId"] token:[weakSelf.token_dic valueForKey:@"token"] status:NO callback:^(NSError *error, BOOL success) {
                if (success) {
                    NSLog(@"SUCCESS ADD PROJECT");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf->projectNameTextField.text = @"";
                        weakSelf->addMembersTextField.text = @"";
                        weakSelf->sprintNameTextField.text = @"";
                        if ([Projects.dict_error valueForKey:@"type"] != nil) {
                            NSString* title = [weakSelf->Projects.dict_error valueForKey:@"title"];
                            NSString* message = [weakSelf->Projects.dict_error valueForKey:@"message"];
                            
                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                
                            }];
                            
                            [alert addAction:defaultAction];
                            [weakSelf presentViewController:alert animated:YES completion:nil];
                            
                        } else {
                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Création réussie" message:@"Votre projet a été créé avec succès." preferredStyle:UIAlertControllerStyleAlert];
                            
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
    addMembersTextField.text = [@(nMember)stringValue];
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


- (void) designPage {
    
    //navigation bar customization
    self.navigationItem.title = [NSString stringWithFormat:@"Ajouter un projet"];
    
    //UINavigationBar* bar = [self.navigationController navigationBar];
    //[bar setHidden:false];
    
    //border projectName text field
    CALayer *borderProjectName = [CALayer layer];
    CGFloat borderWidthProjectName = 1.5;
    borderProjectName.borderColor = [UIColor darkGrayColor].CGColor;
    borderProjectName.frame = CGRectMake(0, projectNameTextField.frame.size.height - borderWidthProjectName, projectNameTextField.frame.size.width, projectNameTextField.frame.size.height);
    borderProjectName.borderWidth = borderWidthProjectName;
    [projectNameTextField.layer addSublayer:borderProjectName];
    projectNameTextField.layer.masksToBounds = YES;
    
    //border addMember text field
    CALayer *borderAddMember = [CALayer layer];
    CGFloat borderWidthAddMember = 1.5;
    borderAddMember.borderColor = [UIColor darkGrayColor].CGColor;
    borderAddMember.frame = CGRectMake(0, addMembersTextField.frame.size.height - borderWidthAddMember, addMembersTextField.frame.size.width, addMembersTextField.frame.size.height);
    borderAddMember.borderWidth = borderWidthAddMember;
    [addMembersTextField.layer addSublayer:borderAddMember];
    addMembersTextField.layer.masksToBounds = YES;
    
    //border labelMember
    CALayer *borderLabelMember = [CALayer layer];
    CGFloat borderWidthLabelMember = 1.5;
    borderLabelMember.borderColor = [UIColor darkGrayColor].CGColor;
    borderLabelMember.frame = CGRectMake(0, labelMembers.frame.size.height - borderWidthLabelMember, labelMembers.frame.size.width, labelMembers.frame.size.height);
    borderLabelMember.borderWidth = borderWidthLabelMember;
    [labelMembers.layer addSublayer:borderLabelMember];
    labelMembers.layer.masksToBounds = YES;
    
    //border sprintName
    CALayer *borderSprintName = [CALayer layer];
    CGFloat borderWidthSprintName = 1.5;
    borderSprintName.borderColor = [UIColor darkGrayColor].CGColor;
    borderSprintName.frame = CGRectMake(0, sprintNameTextField.frame.size.height - borderWidthSprintName, sprintNameTextField.frame.size.width, sprintNameTextField.frame.size.height);
    borderSprintName.borderWidth = borderWidthSprintName;
    [sprintNameTextField.layer addSublayer:borderSprintName];
    sprintNameTextField.layer.masksToBounds = YES;
    
}


- (void) cancelButton:(id)sender {
    UserHomeScreenViewController* UserVc = [[UserHomeScreenViewController alloc] init];
    [self.navigationController pushViewController:UserVc animated:YES];
}


- (IBAction)addMembersButton:(id)sender {
    ScrumBoardScreenViewController* scrumBoardVc = [[ScrumBoardScreenViewController alloc] init];
    [self.navigationController pushViewController:scrumBoardVc animated:YES];
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
