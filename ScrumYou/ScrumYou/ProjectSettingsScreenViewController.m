//
//  ProjectSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ProjectSettingsScreenViewController.h"
#import "APIKeys.h"
#import "GetProjectsById.h"
#import "Project.h"
#import "GetUserById.h"

@interface ProjectSettingsScreenViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

- (void) editProject;

- (void) editMembers;

- (void) cancelButton;

@end

@implementation ProjectSettingsScreenViewController {
    NSMutableArray<Project*>* projects;
    NSMutableArray<User*>* users;
    
    NSMutableArray* members;
    NSMutableArray* ids;
    
    NSArray* searchResults;
    
    UIVisualEffectView *blurEffectView;
    
    GetProjectsById* Projects;
    GetUserById* Users;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        projects = [[NSMutableArray<Project*> alloc] init];
        users = [[NSMutableArray<User*> alloc] init];
        Projects = [[GetProjectsById alloc] init];
        Users = [[GetUserById alloc] init];
        [Projects getProjectById:@"/1" callback:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"SUCCESS");
                projects = Projects.projects_list;
                NSLog(@"p %@", projects);
                [self getProject];
                [self getUser];
            }
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    
    [self designPage];
    
    [membersTableView reloadData];
}


- (void) getProject {
    
    //projects = Projects.projects_list;
    NSLog(@"%@", projects);
    //nameTextField.text = [projects valueForKey:@"title"];
    for (NSString* p in projects) {
        nameTextField.text = [p valueForKey:@"_title"];
    }
}

- (void) getUser {
    
    NSLog(@"project %@", projects);
    
    for (NSMutableArray* membersArray in [projects valueForKey:@"_id_members"]) {
        for (NSString* m in membersArray) {
            NSString* result = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@",m]];
            [Users getUserById:result callback:^(NSError *error, BOOL success) {
                if (success) {
                    NSLog(@"SUCCESS");
                    users = Users.usersList;
                }
                [membersTableView reloadData];
            }];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* const kCellId = @"AZERTYUIOP";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    User* username;
    username = [users objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", username.fullname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void) editMembers {
    
}

- (void) editProject {
    
}

- (void) cancelButton {
    
}

- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Projet NAME"];
    
    UIImage *cancel = [[UIImage imageNamed:@"error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *editProject = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editProject:)];
    self.navigationItem.rightBarButtonItem = editProject;
    
    
    
    //border name project text field
    CALayer *borderName = [CALayer layer];
    CGFloat borderWidthName = 1.5;
    borderName.borderColor = [UIColor darkGrayColor].CGColor;
    borderName.frame = CGRectMake(0, nameTextField.frame.size.height - borderWidthName, nameTextField.frame.size.width, nameTextField.frame.size.height);
    borderName.borderWidth = borderWidthName;
    [nameTextField.layer addSublayer:borderName];
    nameTextField.layer.masksToBounds = YES;
    
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
