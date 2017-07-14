//
//  PageContentViewController.m
//  Scrummary
//
//  Created by Bérangère La Touche on 20/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "PageContentViewController.h"
#import "ScrumBoardCell.h"
#import "Task.h"
#import "AddTaskScreenViewController.h"

@interface PageContentViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

- (void) modifyTask;

@end

@implementation PageContentViewController {
    NSMutableArray<NSMutableArray*>* array;
    NSMutableArray<Task*>* tasks;
    
    NSArray* keys;
    
    Task* current_task;
    
    AddTaskScreenViewController* addTaskVC;
}

@synthesize scrumBoardCollectionView = _scrumBoardCollectionView;
@synthesize dictionary_section = _dictionary_section;
@synthesize array_section = _array_section;
@synthesize array_sprint = _array_sprint;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self designPage];
    
    NSLog(@"dico %@", self.dictionary_section);
    
    self.label.text = self.txtTitle;
    
    addTaskVC = [[AddTaskScreenViewController alloc] init];
    
    current_task = [[Task alloc] init];
    array = [[NSMutableArray<NSMutableArray*> alloc] init];
    tasks = [[NSMutableArray<Task*> alloc] init];
    
    self.menuSprints.delegate = self;
    self.menuSprints.dataSource = self;
    
    keys = [self.dictionary_section allKeys];
    
    self.scrumBoardCollectionView.delegate = self;
    self.scrumBoardCollectionView.dataSource = self;
    
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
    return tasks.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"SBCell";
    
    ScrumBoardCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScrumBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Task* task;
    task = [tasks objectAtIndex:indexPath.row];
    current_task = task;
    
    cell.layer.cornerRadius = 6;
    cell.titleCell.text = task.title;
    cell.descriptionCell.text = task.description;
    
    
    [cell.pencil addTarget:self action:@selector(modifyTask) forControlEvents:UIControlEventTouchUpInside];
    //[cell.pencil performSelector:@selector(modifyTask:) withObject:task];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void) modifyTask {
    
    NSLog(@"CURRENT TASK %@", current_task.title);
    
    addTaskVC.status = true;
    addTaskVC.mTask = current_task;
//    addTaskVC.taskTitleTextField.text = current_task.title;
//    addTaskVC.taskDurationTextField.text = current_task.duration;
//    addTaskVC.taskMembersTextField.text = [NSString stringWithFormat:@"%ld", current_task.id_members.count];
//    addTaskVC.taskCostTextField.text = current_task.businessValue;
//    addTaskVC.taskDifficultyTextField.text = current_task.difficulty;
//    addTaskVC.taskDescriptionTextField.text = current_task.description;
//    [addTaskVC.prioritySegmentation setSelectedSegmentIndex:[current_task.priority integerValue]];
//    [addTaskVC.categorySegmentation setSelectedSegmentIndex:[current_task.id_category integerValue]];
    
    [self.navigationController pushViewController:addTaskVC animated:YES];
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
