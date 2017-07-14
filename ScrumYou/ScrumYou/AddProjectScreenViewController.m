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
#import "CrudAuth.h"

@interface AddProjectScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

@implementation AddProjectScreenViewController {
    NSMutableArray<User*>* get_users;
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSInteger nMember;
    
    NSArray* searchResults;
    
    UIVisualEffectView *blurEffectView;
    
    NSDictionary* auth;

    CrudUsers* Users;
    CrudProjects* Projects;
    LoginScreenViewController* loginVC;
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
    
    [self designPage];
    
    Users = [[CrudUsers alloc] init];
    [Users getUsers:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS GET USERS");
        }
    }];
    
    Projects = [[CrudProjects alloc] init];
    loginVC = [[LoginScreenViewController alloc] init];
    
    get_users = [[NSMutableArray<User*> alloc] init];
    members = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    auth = [[NSDictionary alloc] init];
    
    NSLog(@"TOKEN %@", self.token_dic);
    
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
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [Projects addProjecTitle:projectNameTextField.text members:ids id_creator:[self.token_dic valueForKey:@"userId"] token:[self.token_dic valueForKey:@"token"] callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"SUCCESS ADD PROJECT");
            dispatch_async(dispatch_get_main_queue(), ^{
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
                        
                    }];
                    
                    [alert addAction:defaultAction];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
            });
        }
    }];
    
    projectNameTextField.text = @"";
    addMembersTextField.text = @"";
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
    
    UINavigationBar* bar = [self.navigationController navigationBar];
    [bar setHidden:false];
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
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
