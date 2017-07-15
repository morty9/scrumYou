//
//  PageContentViewController.m
//  Scrummary
//
//  Created by Bérangère La Touche on 20/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "PageContentViewController.h"
#import "ScrumBoardScreenViewController.h"
#import "ScrumBoardCell.h"
#import "Task.h"
#import "AddTaskScreenViewController.h"

@interface PageContentViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

- (void) modifyTask;

@end

@implementation PageContentViewController {
    NSMutableArray<NSMutableArray*>* array;
    NSMutableArray<Task*>* tasks;
    
    NSArray* searchResults;
    NSArray* keys;
    
    Task* current_task;
    
    ScrumBoardScreenViewController* scrumBoardVC;
    AddTaskScreenViewController* addTaskVC;
}

@synthesize scrumBoardCollectionView = _scrumBoardCollectionView;
@synthesize dictionary_section = _dictionary_section;
@synthesize array_section = _array_section;
@synthesize array_sprint = _array_sprint;
@synthesize searchController = _searchController;
@synthesize searchBar = _searchBar;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self designPage];
    
    NSLog(@"dico %@", self.dictionary_section);
    
    self.label.text = self.txtTitle;
    
    addTaskVC = [[AddTaskScreenViewController alloc] init];
    
    current_task = [[Task alloc] init];
    array = [[NSMutableArray<NSMutableArray*> alloc] init];
    tasks = [[NSMutableArray<Task*> alloc] init];
    searchResults = [[NSArray alloc] init];
    
    self.menuSprints.delegate = self;
    self.menuSprints.dataSource = self;
    
    keys = [self.dictionary_section allKeys];
    
    self.scrumBoardCollectionView.delegate = self;
    self.scrumBoardCollectionView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, -5, self.taskView.frame.size.width, 50);
    [self.taskView addSubview:self.searchController.searchBar];
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchController.searchBar setHidden:true];
    
    [self.scrumBoardCollectionView registerNib:[UINib nibWithNibName:@"ScrumBoardCell" bundle:nil]forCellWithReuseIdentifier:@"SBCell"];
    
    [self.scrumBoardCollectionView reloadData];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return keys.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        tasks = [self.dictionary_section objectForKey:[keys objectAtIndex:row]];
        [self.scrumBoardCollectionView reloadData];
    }
    return [keys objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    tasks = [self.dictionary_section objectForKey:[keys objectAtIndex:row]];
    
    [self.scrumBoardCollectionView reloadData];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searchController.isActive) {
        if (self.scrumBoardCollectionView.frame.origin.y == 0) {
            self.scrumBoardCollectionView.frame = CGRectMake(0, 40, self.taskView.frame.size.width, self.scrumBoardCollectionView.frame.size.height - 40);
        }
        return searchResults.count;
    }
    
    return tasks.count;
}

static NSString* cellId = @"SBCell";

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ScrumBoardCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScrumBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Task* task;
    if (self.searchController.isActive) {
        task = [searchResults objectAtIndex:indexPath.row];
    } else {
        task = [tasks objectAtIndex:indexPath.row];
    }
    current_task = task;
    
    cell.layer.cornerRadius = 6;
    cell.titleCell.text = task.title;
    cell.descriptionCell.text = task.description;
    
    [cell.pencil addTarget:self action:@selector(modifyTask) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.isActive) {
        current_task = [searchResults objectAtIndex:indexPath.row];
    } else {
        current_task = [tasks objectAtIndex:indexPath.row];
    }
    
    ScrumBoardCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScrumBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self modifyTask];
}


- (void) modifyTask {
    addTaskVC.status = true;
    addTaskVC.mTask = current_task;
    [self.navigationController pushViewController:addTaskVC animated:YES];
}


// SEARCHBAR

- (void) initializeSearchController {
    [self.searchController.searchBar setHidden:false];
    
    if (self.scrumBoardCollectionView.frame.origin.y == 0) {
        self.scrumBoardCollectionView.frame = CGRectMake(0, 40, self.taskView.frame.size.width, self.scrumBoardCollectionView.frame.size.height - 40);
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    [self searchForText:searchString];
    
    [self.scrumBoardCollectionView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    searchResults = [tasks filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchController.searchBar setHidden:true];
    self.scrumBoardCollectionView.frame = CGRectMake(0, 0, self.taskView.frame.size.width, self.scrumBoardCollectionView.frame.size.height + 40);
}


- (void) designPage {
    
    //border taskCost text field
    CALayer *borderTitle = [CALayer layer];
    CGFloat borderWidthTitle = 1;
    borderTitle.borderColor = [UIColor darkGrayColor].CGColor;
    borderTitle.frame = CGRectMake(0, self.label.frame.size.height - borderWidthTitle, self.label.frame.size.width, self.label.frame.size.height);
    borderTitle.borderWidth = borderWidthTitle;
    [self.label.layer addSublayer:borderTitle];
    self.label.layer.masksToBounds = YES;
    
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
