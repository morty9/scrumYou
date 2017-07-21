//
//  HomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LoginScreenViewController.h"
#import "SignUpScreenViewController.h"
#import "AddProjectScreenViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) designPage {
    self.navigationItem.hidesBackButton = YES;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.27 alpha:1.0];
}

- (IBAction)connectionPage:(id)sender {
    LoginScreenViewController* loginVc = [[LoginScreenViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)inscriptionPage:(id)sender {
    SignUpScreenViewController* signUpVc = [[SignUpScreenViewController alloc] init];
    [self.navigationController pushViewController:signUpVc animated:YES];
}

- (IBAction)testProjectPage:(id)sender {
    AddProjectScreenViewController* addProjectVc = [[AddProjectScreenViewController alloc] init];
    [self.navigationController pushViewController:addProjectVc animated:YES];
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
