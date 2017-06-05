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
#import "APIKeys.h"
#import "User.h"

@interface AddProjectScreenViewController ()


@end

@implementation AddProjectScreenViewController {
    NSMutableArray* user_id;
}

@synthesize users = _users;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self designPage];
    
    user_id = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchAddButton:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[kUserName_api stringByAppendingString:[addMembersTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        if (data == nil) {
            return;
        }
        
        if (response == nil) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [user_id addObject:[jsonDict valueForKey:@"id"]];
            [self addProject];
        });
        
    }] resume];
    
}

- (void) addProject {
    
    NSURL *url = [NSURL URLWithString:kProject_api];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"title" : projectNameTextField.text, @"id_members" : user_id};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
    
        if (data == nil) {
            return;
        }
    
        if (response == nil) {
            return;
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            projectNameTextField.text = @"";
            addMembersTextField.text = @"";
        });
    }] resume];
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
