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

@interface PageContentViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation PageContentViewController {
    NSMutableArray<NSMutableArray*>* array;
    NSMutableArray<Task*>* tasks;
    
    NSArray* keys;
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
    
    NSLog(@"component %ld", component);
    NSLog(@"row %ld", row);
    
    NSLog(@"dico at index %@", [self.dictionary_section objectForKey:[keys objectAtIndex:row]]);
    
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
    
    cell.layer.cornerRadius = 6;
    cell.titleCell.text = task.title;
    cell.descriptionCell.text = task.description;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *selected = [self.tracks objectAtIndex:indexPath.row];
    //NSLog(@"selected=%@", selected);
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
