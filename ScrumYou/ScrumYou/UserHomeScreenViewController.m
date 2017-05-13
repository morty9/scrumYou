//
//  UserHomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UserHomeScreenViewController.h"

@interface UserHomeScreenViewController ()

@end

@implementation UserHomeScreenViewController

@synthesize toolBar = _toolBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
}

- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Scrummary"];

    UIImage *image2 = [[UIImage imageNamed:@"heart3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(touchFavorite:)];
    
    self.navigationItem.rightBarButtonItem = favoriteButton;
    favoriteButton.tintColor = [UIColor grayColor];
    
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
