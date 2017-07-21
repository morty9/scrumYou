//
//  UserHomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UserHomeScreenViewController.h"
#import "AccountSettingsScreenViewController.h"
#import "ScrumBoardScreenViewController.h"
#import "AddProjectScreenViewController.h"
#import "HomeScreenViewController.h"
#import "CellView.h"
#import "Project.h"
#import "Sprint.h"
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"
#import "CrudTasks.h"
#import "CrudAuth.h"
#import "Task.h"
#import "SynchronousMethod.h"

@interface UserHomeScreenViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

@implementation UserHomeScreenViewController {
    
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    CrudTasks* TasksCrud;
    CrudAuth* Auth;
    
    NSMutableArray<Project*>* get_projects;
    NSMutableArray<Project*>* get_projects_by_user;
    NSMutableArray<Sprint*>* get_sprints;
    NSMutableArray<Task*>* get_tasks;
    
    NSMutableArray* finishedProject;
    NSMutableArray* progressProject;
    
    NSInteger countTodo;
    NSInteger countProgress;
    NSInteger countDone;
    
    UIBarButtonItem* addProjectButton;
    
    Task* task;
    
    AccountSettingsScreenViewController* accountSettingsVC;
    ScrumBoardScreenViewController* scrumBoardVC;
    AddProjectScreenViewController* addProjectVC;
    HomeScreenViewController* homeScreenVC;
    
    NSArray* searchResultsFinished;
    NSArray* searchResultsProgress;

}

@synthesize collectionView = _collectionView;
@synthesize searchBar = _searchBar;
@synthesize token = _token;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        NSLog(@"INIT");
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        TasksCrud = [[CrudTasks alloc] init];
        
        addProjectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject:)];
        self.navigationItem.rightBarButtonItem = addProjectButton;
        addProjectButton.tintColor = [UIColor colorWithRed:0.15 green:0.22 blue:0.26 alpha:1.0];
        
        
        get_projects = [[NSMutableArray<Project*> alloc] init];
        get_projects_by_user = [[NSMutableArray<Project*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        get_tasks = [[NSMutableArray<Task*> alloc] init];
        
        finishedProject = [[NSMutableArray alloc] init];
        progressProject = [[NSMutableArray alloc] init];
        
        task = [[Task alloc] init];
        
        [ProjectsCrud getProjects:^(NSError *error, BOOL success) {
            if (success) {
                get_projects = ProjectsCrud.projects_list;
                NSLog(@"GET PROJECTS ARRAY : %@", get_projects);
            }
        }];
        
        [SprintsCrud getSprints:^(NSError *error, BOOL success) {
            if (success) {
                get_sprints = SprintsCrud.sprints_list;
            }
        }];
        
        [TasksCrud getTasks:^(NSError *error, BOOL success) {
            if (success) {
                get_tasks = TasksCrud.tasksList;
            }
        }];
    
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self designPage];
    
    Auth = [[CrudAuth alloc] init];
    accountSettingsVC = [[AccountSettingsScreenViewController alloc] init];
    
    NSLog(@"TOKEN USER HOME %@", _token);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.otherCollectionView.delegate = self;
    self.otherCollectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
    [self.otherCollectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
    [self checkUsersProjects:get_projects tokenActive:_token];
    
    NSLog(@"GET USERS PROJECTS %@", get_projects_by_user);
    [self countProject];
    
    [self.collectionView reloadData];
    [self.otherCollectionView reloadData];
    
    [self updateViewConstraints];
    
}

- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Scrummary"];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *cancel = [[UIImage imageNamed:@"logout-button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searchController.isActive) {
        if (collectionView == self.collectionView) {
            return searchResultsProgress.count;
        }
        return searchResultsFinished.count;
    } else {
        if (collectionView == self.collectionView) {
            return progressProject.count;
        }
        return finishedProject.count;
    }
    
}


- (void) checkUsersProjects:(NSArray*)user_projects tokenActive:(NSDictionary*)tokenActive {
    
    NSNumber* tokenUserId = [tokenActive valueForKey:@"userId"];
    
    for (Project* project in user_projects) {
        for (NSNumber* id_members in [project valueForKey:@"id_members"]) {
            if (tokenUserId == id_members || tokenUserId == [project valueForKey:@"id_creator"]) {
                [get_projects_by_user addObject:project];
                break;
            }
        }
    }
    NSLog(@"GET USERS PROJECTS BEFORE %@", get_projects_by_user);
    
}

- (void) countProject {
    for (Project* p in get_projects_by_user) {
        if ([[p valueForKey:@"status"] boolValue] == NO) {
            [progressProject addObject:p];
            
        } else {
            [finishedProject  addObject:p];
        }
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString* cellId = @"Cell";
    
    CellView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Project* project;
    
    if (self.searchController.isActive) {
        if (collectionView == self.collectionView) {
            project = [searchResultsProgress objectAtIndex:indexPath.row];
        } else {
            project = [searchResultsFinished objectAtIndex:indexPath.row];
        }
    } else {
        if (collectionView == self.collectionView) {
            project = [progressProject objectAtIndex:indexPath.row];
        } else {
            project = [finishedProject objectAtIndex:indexPath.row];
        }

    }

    cell.label.text = project.title;
    NSInteger countSprint = 0;
    
    if ([project.id_sprints isKindOfClass:[NSNull class]]) {
        countSprint = 0;
    } else {
        countSprint = project.id_sprints.count;
    }
    
    [self getSprintsById:project.id_sprints];
    
    cell.nSprint.text = [NSString stringWithFormat:@"%@",  @(countSprint)];
    cell.nTaskTodo.text = [NSString stringWithFormat:@"%@", @(countTodo)];
    cell.nTaskProgress.text = [NSString stringWithFormat:@"%@", @(countProgress)];
    cell.nTaskDone.text = [NSString stringWithFormat:@"%@", @(countDone)];
    
    return cell;
    
}

- (void) getSprintsById:(NSArray*)array_sprints {
    
    for (Sprint* sprints in get_sprints) {
        for (NSNumber* id_sprints in array_sprints) {
            if ([sprints valueForKey:@"_id_sprint"] == id_sprints) {
                NSLog(@"GET TASK");
                [self getTaskById:sprints.id_listTasks];
            }
        }
    }

}

- (void) getTaskById:(NSArray*)array_tasks {
    
    NSLog(@"ARRAY TASKS %@", array_tasks);
    
    NSMutableArray<Task*>* array_t = [[NSMutableArray alloc] init];
    countTodo = 0;
    countProgress = 0;
    countDone = 0;
    
    for (Task* tasks in get_tasks) {
        if (![array_tasks isKindOfClass:[NSNull class]]) {
            for (NSNumber* id_tasks in array_tasks) {
                if ([tasks valueForKey:@"_id_task"] == id_tasks) {
                    [array_t addObject:tasks];
                    if ([[tasks valueForKey:@"_status"] isEqualToString:@"A faire"]) {
                        countTodo += 1;
                    } else if ([[tasks valueForKey:@"_status"] isEqualToString:@"En cours"]) {
                        countProgress += 1;
                    } else {
                        countDone += 1;
                    }
                }
            }
        }
    }
    
    NSLog(@"ARRAY T %@", array_t);
    
}

- (void) getStatusTasks:(Task*)currentTask {
    
    if ([currentTask.status isEqualToString:@"A faire"]) {
        countTodo += 1;
    } else if ([currentTask.status isEqualToString:@"En cours"]) {
        countProgress += 1;
    } else {
        countDone += 1;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    scrumBoardVC = [[ScrumBoardScreenViewController alloc] init];
    
    if (collectionView == self.collectionView) {
        NSLog(@"OBJECT %@", [[progressProject objectAtIndex:indexPath.row] valueForKey:@"id_project"]);
        scrumBoardVC.token = _token;
        scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", [[progressProject objectAtIndex:indexPath.row] valueForKey:@"id_project"]];
    } else {
        NSLog(@"OBJECT %@", [[finishedProject objectAtIndex:indexPath.row] valueForKey:@"id_project"]);
        scrumBoardVC.token = _token;
        scrumBoardVC.id_project = [NSString stringWithFormat:@"%@", [[finishedProject objectAtIndex:indexPath.row] valueForKey:@"id_project"]];
    }
    
    [self.navigationController pushViewController:scrumBoardVC animated:YES];
    
}


- (IBAction)userSettings:(id)sender {
    accountSettingsVC.token = self.token;
    accountSettingsVC.projects_by_user = get_projects_by_user;
    [self.navigationController pushViewController:accountSettingsVC animated:YES];
}

- (IBAction)searchProjects:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
}


- (void) addProject:(id)sender {
    addProjectVC = [[AddProjectScreenViewController alloc] init];
    addProjectVC.token_dic = self.token;
    [self.navigationController pushViewController:addProjectVC animated:YES];
}

- (IBAction)logoutButton:(id)sender {
    homeScreenVC = [[HomeScreenViewController alloc] init];
    
    NSString* tokenid = [self.token valueForKey:@"tokenId"];
    NSString* tokenToken = [self.token valueForKey:@"token"];
    
    NSLog(@"TOKENID to delete: %@", tokenid);
    NSLog(@"TOKEN: %@", self.token);
    
    [Auth logout:tokenid tokenToken:tokenToken callback:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"LOGOUT OK !!!!!!!!!");
        }
    }];
    
    [self.navigationController pushViewController:homeScreenVC animated:YES];
}

// SEARCHBAR

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    [self searchForText:searchString];
    
    [self.collectionView reloadData];
    [self.otherCollectionView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    searchResultsProgress = [progressProject filteredArrayUsingPredicate:predicate];
    searchResultsFinished = [finishedProject filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationItem.titleView = nil;
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
