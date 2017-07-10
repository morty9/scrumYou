//
//  UserHomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UserHomeScreenViewController.h"
#import "CellView.h"
#import "Project.h"
#import "Sprint.h"
#import "CrudUsers.h"
#import "CrudProjects.h"
#import "CrudSprints.h"
#import "CrudTasks.h"
#import "Task.h"

@interface UserHomeScreenViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation UserHomeScreenViewController {
    
    NSMutableArray<Project*>* get_projects;
    NSMutableArray<Sprint*>* get_sprints;
    NSMutableArray<Task*>* get_tasks;
    
    CrudProjects* ProjectsCrud;
    CrudSprints* SprintsCrud;
    CrudTasks * TasksCrud;
    
    Task* task;
    
    NSMutableArray* finishedProject;
    NSMutableArray* progressProject;
    
    NSInteger countTodo;
    NSInteger countProgress;
    NSInteger countDone;
}

@synthesize collectionView = _collectionView;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        get_projects = [[NSMutableArray<Project*> alloc] init];
        get_sprints = [[NSMutableArray<Sprint*> alloc] init];
        get_tasks = [[NSMutableArray<Task*> alloc] init];
        
        ProjectsCrud = [[CrudProjects alloc] init];
        SprintsCrud = [[CrudSprints alloc] init];
        TasksCrud = [[CrudTasks alloc] init];
        
        finishedProject = [[NSMutableArray alloc] init];
        progressProject = [[NSMutableArray alloc] init];
        
        task = [[Task alloc] init];
        
        
        
        
        [ProjectsCrud getProjects:^(NSError *error, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    get_projects = ProjectsCrud.projects_list;
                    NSLog(@"GET PROJECTS %@", get_projects);
                    [self countProject];
                    
                    [self.collectionView reloadData];
                    [self.otherCollectionView reloadData];
                });
                
            }
        }];
        
        [SprintsCrud getSprints:^(NSError *error, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    get_sprints = SprintsCrud.sprints_list;
                    NSLog(@"GET SPRINTS %@", get_sprints);
                }
            });
            
        }];
        
        [TasksCrud getTasks:^(NSError *error, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    get_tasks = TasksCrud.tasksList;
                    NSLog(@"GET TASKS %@", get_tasks);
                }
            });
            
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
  
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.otherCollectionView.delegate = self;
    self.otherCollectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
    [self.otherCollectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
}


- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Scrummary"];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.collectionView) {
        return progressProject.count;
    }
    
    return finishedProject.count;
}

- (void) countProject {
    for (Project* p in get_projects) {
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
    
    if (collectionView == self.collectionView) {
        project = [progressProject objectAtIndex:indexPath.row];
    } else {
        project = [finishedProject objectAtIndex:indexPath.row];
    }
    
    cell.label.text = project.title;
    NSInteger countSprint = 0;
    
    if ([project.id_sprints isKindOfClass:[NSNull class]]) {
        countSprint = 0;
    } else {
        countSprint = project.id_sprints.count;
    }
    
    [self getSprintsById:project.id_sprints];
    NSLog(@"BALBLA %@", [project valueForKey:@"id_sprints"]);
    NSLog(@"COUNT TODO %ld", countTodo);
    NSLog(@"COUNT PROGRESS %ld", countProgress);
    NSLog(@"COUNT DONE %ld", countDone);
    
    //[self getSprintsById:project.id_sprints];
    
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
    
    NSMutableArray<Task*>* array_t = [[NSMutableArray alloc] init];
    countTodo = 0;
    countProgress = 0;
    countDone = 0;
    
    for (Task* tasks in get_tasks) {
        for (NSNumber* id_tasks in array_tasks) {
            if ([tasks valueForKey:@"_id_task"] == id_tasks) {
                [array_t addObject:tasks];
                if ([[tasks valueForKey:@"_status"] isEqualToString:@"todo"]) {
                    countTodo += 1;
                } else if ([[tasks valueForKey:@"_status"] isEqualToString:@"progress"]) {
                    countProgress += 1;
                } else {
                    countDone += 1;
                }
            }
        }
    }
    
    NSLog(@"ARRAY T %@", array_t);
    
}

/*- (void) getSprintsById:(NSArray*)id_sprints {
    
    get_sprints = [[NSMutableArray alloc] init];
    
    for (NSNumber* idS in id_sprints) {
        NSLog(@"IDS %@", idS);
        [SprintsCrud getSprintById:[idS stringValue] callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS SPRINTS");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[get_sprints addObject:SprintsCrud.sprint];
                    NSLog(@"GO TO GETTASKBYID");
                    [self getTaskById:SprintsCrud.sprint];
                });
                
                //NSLog(@"GET_SPRINTS %@", [get_sprints valueForKey:@"id_sprint"]);
            }
        }];
    }
    
}

- (void) getTaskById:(Sprint*)sprint {
    
    for (NSNumber* taskId in sprint.id_listTasks) {
        [TasksCrud getTaskById:[NSString stringWithFormat:@"%@", taskId] callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS TASKS ID");
                dispatch_async(dispatch_get_main_queue(), ^{
                    task = TasksCrud.task;
                    [self getStatusTasks:task];
                    //NSLog(@"COUNT TODO %ld", (long)countTodo);
                });
                
            }
        }];

    }
}*/

- (void) getStatusTasks:(Task*)currentTask {
    
    if ([currentTask.status isEqualToString:@"todo"]) {
        countTodo += 1;
    } else if ([currentTask.status isEqualToString:@"progress"]) {
        countProgress += 1;
    } else {
        countDone += 1;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [self.tracks objectAtIndex:indexPath.row];
}

- (void) backHome {
    
}

- (void) search {
    
}

- (void) chat {
    
}

- (void) settings {
    
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
