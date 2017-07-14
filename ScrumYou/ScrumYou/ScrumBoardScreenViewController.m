//
//  ScrumBoardScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ScrumBoardScreenViewController.h"
#import "PageContentViewController.h"
#import "PageViewController.h"
#import "CrudTasks.h"
#import "Task.h"
#import "Sprint.h"
#import "Project.h"
#import "CrudProjects.h"
#import "CrudSprints.h"

@interface ScrumBoardScreenViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

@end

@implementation ScrumBoardScreenViewController {
    
    CrudTasks* TasksCrud;
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    
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

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        NSLog(@"INIT");
        
        TasksCrud = [[CrudTasks alloc] init];
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        
        get_tasks = [[NSMutableArray<Task*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        project = [[Project alloc] init];
    
        tasks_array_todo = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        tasks_array_progress = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        tasks_array_done = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        
        arrayTodo = [[NSMutableArray<Task*> alloc] init];
        arrayProgress = [[NSMutableArray<Task*> alloc] init];
        arrayDone = [[NSMutableArray<Task*> alloc] init];
        
        [ProjectsCrud getProjectById:self.id_project callback:^(NSError *error, BOOL success) {
            if (success) {
                project = ProjectsCrud.project;
                self.navigationItem.title = project.title;
                [self getSprintsByProject:project.id_sprints];
                [self getTasksBySprint:get_sprints];
                [self initializeDictionarys:get_tasks andSprint:get_sprints];
            }
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
    _pageTitles = @[@"Todo", @"In Progress", @"Done"];

    // Create page view controllerinstantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];
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
        for (NSNumber* id_tasks in [sprint valueForKey:@"id_listTasks"]) {
            NSString* idT = [NSString stringWithFormat:@"%@", id_tasks];
            [TasksCrud getTaskById:idT callback:^(NSError *error, BOOL success) {
                if (success) {
                    [get_tasks addObject:TasksCrud.task];
                }
            }];
        }
    }
    
}

- (void) initializeDictionarys:(NSArray*)tasks andSprint:(NSArray*)sprints {
    
    for (Sprint* sprint in sprints) {
    
        arrayTodo = [[NSMutableArray alloc] init];
        arrayProgress = [[NSMutableArray alloc] init];
        arrayDone = [[NSMutableArray alloc] init];
        
        for (NSNumber* idT in [sprint valueForKey:@"id_listTasks"]) {
            for (Task* t in tasks) {
                if ([t.id_task isEqual:idT]) {
                    if ([[t valueForKey:@"status"]  isEqual: @"A faire"]) {
                        [arrayTodo addObject:t];
                        [tasks_array_todo setObject:arrayTodo forKey:sprint.title];
                    } else if ([[t valueForKey:@"status"] isEqual:@"En cours"]) {
                        [arrayProgress addObject:t];
                        [tasks_array_progress setObject:arrayProgress forKey:sprint.title];
                    } else {
                        [arrayDone addObject:t];
                        [tasks_array_done setObject:arrayDone forKey:sprint.title];
                    }
                }
            }
        }
    }
    
    NSLog(@"task todo %@", tasks_array_todo);
    NSLog(@"task progress %@", tasks_array_progress);
    NSLog(@"task done %@", tasks_array_done);
}

- (void) designPage {
    
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
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] initWithNibName:@"PageContentViewController" bundle:nil];
    
    pageContentViewController.txtTitle = self.pageTitles[index];
    if (index == 0) {
        pageContentViewController.dictionary_section = tasks_array_todo;
        [pageContentViewController.scrumBoardCollectionView reloadData];
    } else if (index == 1) {
        pageContentViewController.dictionary_section = tasks_array_progress;
        [pageContentViewController.scrumBoardCollectionView reloadData];
    } else if (index == 2) {
        pageContentViewController.dictionary_section = tasks_array_done;
        [pageContentViewController.scrumBoardCollectionView reloadData];
    }
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
