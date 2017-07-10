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
    
    NSMutableArray<Task*>* get_tasks;
    NSMutableArray<Sprint*>* get_sprints;
    
    NSMutableDictionary<NSString*, NSMutableDictionary*>* todoDictionary;
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* progressDictionary;
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* doneDictionary;
    NSMutableDictionary<NSString*, NSMutableArray<Task*>*>* bugDictionary;
    
    //NSMutableArray<Task*>* tasks_array_todo;
    NSMutableDictionary<NSString*, Task*>* tasks_array_todo;
    NSMutableArray<Task*>* tasks_array_progress;
    NSMutableArray<Task*>* tasks_array_done;
    
    Project* project;
    
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        NSLog(@"INIT");
        
        TasksCrud = [[CrudTasks alloc] init];
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        
        todoDictionary = [[NSMutableDictionary<NSString*, NSMutableDictionary*> alloc] init];
        progressDictionary = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        doneDictionary = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        bugDictionary = [[NSMutableDictionary<NSString*, NSMutableArray<Task*>*> alloc] init];
        
        get_tasks = [[NSMutableArray<Task*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        project = [[Project alloc] init];
        //tasks_array_todo = [[NSMutableArray<Task*> alloc] init];
        tasks_array_todo = [[NSMutableDictionary<NSString*, Task*> alloc] init];
        tasks_array_progress = [[NSMutableArray<Task*> alloc] init];
        tasks_array_done = [[NSMutableArray<Task*> alloc] init];
        
        NSLog(@"DISPATCH PROJECTS");
        [ProjectsCrud getProjectById:@"54" callback:^(NSError *error, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    project = ProjectsCrud.project;
                    NSLog(@"Project %@", project);
                    self.navigationItem.title = project.title;
                    [self getSprintsByProject:project.id_sprints];
                });
            }
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
    NSLog(@"VIEWDIDLOAD");
    
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
    
    NSLog(@"GET SPRINTS BY PROJECT");
    for (NSNumber* id_sprints in array_sprints) {
        NSString* idS = [id_sprints stringValue];
        [SprintsCrud getSprintById:idS callback:^(NSError *error, BOOL success) {
            if (success) {
                //NSLog(@"GET SPRINTS SUCCESS");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [get_sprints addObject:SprintsCrud.sprint];
                    [self getTasksBySprint:SprintsCrud.sprint];
                });
            }
        }];
    }
    
}

- (void) getTasksBySprint:(Sprint*)sprint {
    
    __block NSInteger count = 0;
    
    NSLog(@"GET TASKS BY SPRINT");
    for (NSNumber* id_tasks in [sprint valueForKey:@"id_listTasks"]) {
        NSLog(@"id_tasks %@", id_tasks);
        NSString* idT = [id_tasks stringValue];
        NSLog(@"IDT %@", idT);
        [TasksCrud getTaskById:idT callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"GET TASKS SUCCESS");
                
                [get_tasks addObject:TasksCrud.task];
                count += 1;
                    
                if (count == sprint.id_listTasks.count) {
                    [self initializeDictionarys:get_tasks andSprint:sprint];
                }
            }
        }];
    }
    
}

- (void) initializeDictionarys:(NSMutableArray*)task andSprint:(Sprint*)spr {

    NSLog(@"INITIALIZE DICTIONARYS");

    NSLog(@"TASKS %@", get_tasks);
    for (Task* t in get_tasks) {
        if ([[t valueForKey:@"status"]  isEqual: @"todo"]) {
            //[tasks_array_todo addObject:t];
            [tasks_array_todo setValue:t forKey:[NSString stringWithFormat:@"%@", spr.id_sprint]];
            //[todoDictionary setValue:tasks_array_todo forKey:[NSString stringWithFormat:@"%@", spr.id_sprint]];
            [todoDictionary setValue:tasks_array_todo forKey:@"todo"];
        } else if ([[t valueForKey:@"status"] isEqual:@"progress"]) {
            [tasks_array_progress addObject:t];
            [progressDictionary setValue:tasks_array_progress forKey:@"progress"];
        } else {
            [tasks_array_done addObject:t];
            [doneDictionary setValue:tasks_array_done forKey:@"done"];
        }
    }
    
    [get_tasks removeAllObjects];
    NSLog(@"task todo %@", tasks_array_todo);
    NSLog(@"task todo dico %@", todoDictionary);
    NSLog(@"task progress %@", tasks_array_progress);
    NSLog(@"task progress dico %@", progressDictionary);
    NSLog(@"task done %@", tasks_array_done);
    NSLog(@"task done dico %@", doneDictionary);
}


- (void) designPage {
    
    NSLog(@"DESIGN PAGE");
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"PAGEVIEWCONTROLLER1");
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"PAGEVIEWCONTROLLER 2");
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
    NSLog(@"VIEWCONTROLLERATINDEX");
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] initWithNibName:@"PageContentViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        pageContentViewController.txtTitle = self.pageTitles[index];
        pageContentViewController.array_section = tasks_array_todo;
        [pageContentViewController.scrumBoardCollectionView reloadData];
        /*if (index == 0) {
         pageContentViewController.array_section = tasks_array_todo;
         [pageContentViewController.scrumBoardCollectionView reloadData];
         } else*/ if (index == 1) {
             pageContentViewController.array_section = tasks_array_progress;
             [pageContentViewController.scrumBoardCollectionView reloadData];
         } else if (index == 2) {
             pageContentViewController.array_section = tasks_array_done;
             [pageContentViewController.scrumBoardCollectionView reloadData];
         }
        //pageContentViewController.array_section =
        pageContentViewController.pageIndex = index;

    });
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    NSLog(@"PRESENTATION 1");
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    NSLog(@"PRESENTATION 2");
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
