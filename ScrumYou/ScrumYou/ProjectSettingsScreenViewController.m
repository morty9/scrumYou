//
//  ProjectSettingsScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ProjectSettingsScreenViewController.h"
#import "APIKeys.h"

@interface ProjectSettingsScreenViewController ()

@end

@implementation ProjectSettingsScreenViewController {
    NSMutableArray* projects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    projects = [[NSMutableArray alloc] init];
    [self getProject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getProject {
    
    NSURL *url = [NSURL URLWithString:[kProject_api stringByAppendingString:@"/1"]];
    
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
        
        NSLog(@"project %@", jsonDict);
        NSLog(@"%@", [jsonDict objectForKey:@"title"]);
        nameTextField.text = [jsonDict objectForKey:@"title"];
        
        
        
    }] resume];
    
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
