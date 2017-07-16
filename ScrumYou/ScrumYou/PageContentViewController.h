//
//  PageContentViewController.h
//  Scrummary
//
//  Created by Bérangère La Touche on 20/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Sprint.h"
#import "Project.h"

@interface PageContentViewController : UIViewController {
    NSDictionary* _dictionary_section;
    NSArray<Task*>* _array_section;
    NSArray<Sprint*>* _array_sprint;
    Project* _current_project;
}

@property (nonatomic, strong) NSDictionary* dictionary_section;
@property (nonatomic, strong) NSArray<Task*>* array_section;
@property (nonatomic, strong) NSArray<Sprint*>* array_sprint;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UICollectionView *scrumBoardCollectionView;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIPickerView *menuSprints;
@property (nonatomic, strong) Project* current_project;
@property NSUInteger pageIndex;
@property NSString *txtTitle;


- (void) initializeSearchController;

@end

