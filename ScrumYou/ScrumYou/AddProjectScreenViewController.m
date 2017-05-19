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

@interface AddProjectScreenViewController ()

@end

@implementation AddProjectScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
