//
//  ScrumBoardScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrumBoardScreenViewController : UIViewController {
    
    NSString* _id_project;
    NSDictionary* _token;
    
    BOOL _comeUpdateTask;
    BOOL _comeDeleteTask;
    BOOL _comeAddTask;
}

@property (weak, nonatomic) IBOutlet UIButton *startAgain;
@property (nonatomic, strong) NSString* id_project;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButtonItem;
@property (nonatomic, strong) NSDictionary *token;
@property (nonatomic) BOOL comeUpdateTask;
@property (nonatomic) BOOL comeDeleteTask;
@property (nonatomic) BOOL comeAddTask;

@end
