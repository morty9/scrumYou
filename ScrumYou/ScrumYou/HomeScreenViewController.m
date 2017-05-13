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

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) designPage {
    
    UINavigationBar* bar = [self.navigationController navigationBar];
    [bar setHidden:TRUE];
}

- (IBAction)connectionPage:(id)sender {
    LoginScreenViewController* loginVc = [[LoginScreenViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)inscriptionPage:(id)sender {
    SignUpScreenViewController* signUpVc = [[SignUpScreenViewController alloc] init];
    [self.navigationController pushViewController:signUpVc animated:YES];
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
