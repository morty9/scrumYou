//
//  ScrumBoardScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ScrumBoardScreenViewController.h"
#import "UserHomeScreenViewController.h"
#import "HomeScreenViewController.h"
#import "AccountSettingsScreenViewController.h"
#import "ProjectSettingsScreenViewController.h"
#import "AddTaskScreenViewController.h"
#import "PageContentViewController.h"
#import "PageViewController.h"
#import "CrudTasks.h"
#import "CrudAuth.h"
#import "Task.h"
#import "Sprint.h"
#import "Project.h"
#import "CrudProjects.h"
#import "CrudSprints.h"

@interface ScrumBoardScreenViewController () <UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

- (void) addTask;

- (void) settingsProject;

@end

@implementation ScrumBoardScreenViewController {
    
    UserHomeScreenViewController* userHomeVC;
    PageContentViewController *pageContentVC;
    AccountSettingsScreenViewController* accountSettingsVC;
    AddTaskScreenViewController* addTaskVC;
    ProjectSettingsScreenViewController* projectSettingsVC;
    HomeScreenViewController* homeScreenVC;
    
    CrudTasks* TasksCrud;
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    CrudAuth* Auth;
    
    Project* project;
    
    NSMutableArray<Task*>* get_tasks;
    NSMutableArray<Sprint*>* get_sprints;
    
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* tasks_array_todo;
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* tasks_array_progress;
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* tasks_array_done;
    
    NSMutableArray<Task*>* arrayTodo;
    NSMutableArray<Task*>* arrayProgress;
    NSMutableArray<Task*>* arrayDone;
}

@synthesize id_project = _id_project;
@synthesize token = _token;
@synthesize comeUpdateTask = _comeUpdateTask;
@synthesize comeDeleteTask = _comeDeleteTask;
@synthesize comeAddTask = _comeAddTask;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        TasksCrud = [[CrudTasks alloc] init];
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        Auth = [[CrudAuth alloc] init];
        
        get_tasks = [[NSMutableArray<Task*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        project = [[Project alloc] init];
    
        tasks_array_todo = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        tasks_array_progress = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        tasks_array_done = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        
        arrayTodo = [[NSMutableArray<Task*> alloc] init];
        arrayProgress = [[NSMutableArray<Task*> alloc] init];
        arrayDone = [[NSMutableArray<Task*> alloc] init];
        
        accountSettingsVC = [[AccountSettingsScreenViewController alloc] init];
        addTaskVC = [[AddTaskScreenViewController alloc] init];
        projectSettingsVC = [[ProjectSettingsScreenViewController alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    NSLog(@"VIEW DID LOAD");
    
    [ProjectsCrud getProjectById:self.id_project callback:^(NSError *error, BOOL success) {
        if (success) {
            project = ProjectsCrud.project;
            NSLog(@"PROJECT %@", project);
            self.navigationItem.title = project.title;
            [self getSprintsByProject:project.id_sprints];
            [self getTasksBySprint:get_sprints];
            [self initializeDictionarys:get_tasks andSprint:get_sprints];
        }
    }];
    
    [self designPage];
    
    NSLog(@"USER TOKEN SB %@", _token);
    
    _pageTitles = @[@"A faire", @"En cours", @"Finies"];

    // Create page view controllerinstantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];
    self.pageViewController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 75);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = project.title;
}

- (void) getSprintsByProject:(NSArray*)array_sprints {

    for (NSNumber* id_sprints in array_sprints) {
        NSString* idS = [id_sprints stringValue];
        [SprintsCrud getSprintById:idS callback:^(NSError *error, BOOL success) {
            if (success) {
                [get_sprints addObject:SprintsCrud.sprint];
            }
        }];
    }
    
}

- (void) getTasksBySprint:(NSMutableArray*)get_sprint {
    
    for (Sprint* sprint in get_sprint) {
        if (![sprint.id_listTasks isKindOfClass:[NSNull class]]) {
            for (NSNumber* id_tasks in sprint.id_listTasks) {
                NSString* idT = [NSString stringWithFormat:@"%@", id_tasks];
                [TasksCrud getTaskById:idT callback:^(NSError *error, BOOL success) {
                    if (success) {
                        [get_tasks addObject:TasksCrud.task];
                    }
                }];
            }
        }
    }
    
}

- (void) initializeDictionarys:(NSArray*)tasks andSprint:(NSArray*)sprints {

    if (sprints.count == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sprint manquant" message:@"Pour accéder au Scrum Board vous devez créer au moins un sprint" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            projectSettingsVC = [[ProjectSettingsScreenViewController alloc] init];
            projectSettingsVC.token_dic = _token;
            //projectSettingsVC.current_project = [NSString stringWithFormat:@"%@", project.id_project];
            [self.navigationController pushViewController:projectSettingsVC animated:YES];
            
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    for (int i = (int)sprints.count-1; i >= 0; i--) {
        NSLog(@"SPRINT ID %@", [sprints[i] valueForKey:@"id_sprint"]);
        
        arrayTodo = [[NSMutableArray alloc] init];
        arrayProgress = [[NSMutableArray alloc] init];
        arrayDone = [[NSMutableArray alloc] init];
        
        if (![[sprints[i] valueForKey:@"id_listTasks"] isKindOfClass:[NSNull class]]) {
            for (NSNumber* idT in [sprints[i] valueForKey:@"id_listTasks"]) {
                for (Task* t in tasks) {
                    if ([t.id_task isEqual:idT]) {
                        if ([[t valueForKey:@"status"] isEqual: @"A faire"]) {
                            [arrayTodo addObject:t];
                            [tasks_array_todo setObject:arrayTodo forKey:[sprints[i] valueForKey:@"title"]];
                        } else if ([[t valueForKey:@"status"] isEqual:@"En cours"]) {
                            [arrayProgress addObject:t];
                            [tasks_array_progress setObject:arrayProgress forKey:[sprints[i] valueForKey:@"title"]];
                        } else {
                            [arrayDone addObject:t];
                            [tasks_array_done setObject:arrayDone forKey:[sprints[i] valueForKey:@"title"]];
                        }
                    }
                }
            }
        }
        
        if (arrayTodo.count == 0) {
            Task* emptyTask = [[Task alloc] initWithId:@"" title:@"Pas de tâche" description:@"" difficulty:@"" priority:@"" id_category:@"" businessValue:@"" duration:@"" status:@"" id_creator:@"" taskDone:nil id_members:nil];
            NSLog(@"empty task %@", emptyTask.title);
            [arrayTodo addObject:emptyTask];
            [tasks_array_todo setObject:arrayTodo forKey:[sprints[i] valueForKey:@"title"]];
        }
        
        if (arrayProgress.count == 0) {
            Task* emptyTask = [[Task alloc] initWithId:@"" title:@"Pas de tâche" description:@"" difficulty:@"" priority:@"" id_category:@"" businessValue:@"" duration:@"" status:@"" id_creator:@"" taskDone:nil id_members:nil];
            NSLog(@"empty task %@", emptyTask.title);
            [arrayProgress addObject:emptyTask];
            [tasks_array_progress setObject:arrayProgress forKey:[sprints[i] valueForKey:@"title"]];
        }
        
        if (arrayDone.count == 0) {
            Task* emptyTask = [[Task alloc] initWithId:@"" title:@"Pas de tâche" description:@"" difficulty:@"" priority:@"" id_category:@"" businessValue:@"" duration:@"" status:@"" id_creator:@"" taskDone:nil id_members:nil];
            NSLog(@"empty task %@", emptyTask.title);
            [arrayDone addObject:emptyTask];
            [tasks_array_done setObject:arrayDone forKey:[sprints[i] valueForKey:@"title"]];
        }

    }
    
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    pageContentVC = [[PageContentViewController alloc] initWithNibName:@"PageContentViewController" bundle:nil];
    
    pageContentVC.txtTitle = self.pageTitles[index];
    pageContentVC.array_sprint = get_sprints;
    NSLog(@"CURRENT PROJECT %@", project);
    pageContentVC.current_project = project;
    pageContentVC.token = self.token;
    if (index == 0) {
        pageContentVC.dictionary_section = tasks_array_todo;
        [pageContentVC.scrumBoardCollectionView reloadData];
    } else if (index == 1) {
        pageContentVC.dictionary_section = tasks_array_progress;
        [pageContentVC.scrumBoardCollectionView reloadData];
    } else if (index == 2) {
        pageContentVC.dictionary_section = tasks_array_done;
        [pageContentVC.scrumBoardCollectionView reloadData];
    }
    pageContentVC.pageIndex = index;
    
    return pageContentVC;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

//TOOLBAR

/*
 *  IBAction -> Back to user Home controller
 */
- (IBAction)backToUserHome:(id)sender {
    userHomeVC = [[UserHomeScreenViewController alloc] init];
    userHomeVC.token = self.token;
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

- (IBAction)searchTask:(id)sender {
    [pageContentVC initializeSearchController];
}


- (IBAction)userSettings:(id)sender {
    accountSettingsVC.token = self.token;
    [self.navigationController pushViewController:accountSettingsVC animated:YES];
}

- (void) settingsProject {
    projectSettingsVC.token_dic = _token;
    projectSettingsVC.currentProject = project;
    [self.navigationController pushViewController:projectSettingsVC animated:YES];
}

- (void) addTask {
    addTaskVC.status = 0;
    addTaskVC.cProject = project;
    addTaskVC.sprintsByProject = get_sprints;
    NSLog(@"TOKEN ADD TASK %@", self.token);
    [self.navigationController pushViewController:addTaskVC animated:YES];
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


- (void) designPage {
    
    self.navigationItem.title = project.title;
    
//    if (_comeUpdateTask == true || _comeAddTask == true || _comeDeleteTask == true) {
//        self.navigationItem.hidesBackButton = YES;
//        UIImage *backFromModify = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:backFromModify style:UIBarButtonItemStylePlain target:self action:@selector(backToUserHome:)];
//        self.navigationItem.leftBarButtonItem = newBackButton;
//        _comeUpdateTask = false;
//        _comeDeleteTask = false;
//        _comeAddTask = false;
//    }
    
    if (_comeAddTask == true) {
        self.navigationItem.hidesBackButton = YES;
        UIImage *backFromModify = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:backFromModify style:UIBarButtonItemStylePlain target:self action:@selector(backToUserHome:)];
        self.navigationItem.leftBarButtonItem = newBackButton;
        _comeAddTask = false;
    }
    
//    if (_comeDeleteTask == true) {
//        self.navigationItem.hidesBackButton = YES;
//        UIImage *backFromDelete = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backFromDelete style:UIBarButtonItemStylePlain target:self action:@selector(backToUserHome:)];
//        self.navigationItem.leftBarButtonItem = backButton;
//        _comeDeleteTask = false;
//    }
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    addButton.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
    
    UIImage *settings = [[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:settings style:UIBarButtonItemStylePlain target:self action:@selector(settingsProject)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:settingsButton, addButton, nil]];
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
