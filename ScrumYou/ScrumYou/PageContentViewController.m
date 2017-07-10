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

@interface PageContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation PageContentViewController

@synthesize scrumBoardCollectionView = _scrumBoardCollectionView;
@synthesize dictionary_section = _dictionary_section;
@synthesize array_section = _array_section;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = self.txtTitle;
    
    self.scrumBoardCollectionView.delegate = self;
    self.scrumBoardCollectionView.dataSource = self;
    
    [self.scrumBoardCollectionView registerNib:[UINib nibWithNibName:@"ScrumBoardCell" bundle:nil]forCellWithReuseIdentifier:@"SBCell"];
    
    [self.scrumBoardCollectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"%lu", (unsigned long)self.tracks.count);
    //return self.tracks.count;
    return self.array_section.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"SBCell";
    
    ScrumBoardCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScrumBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Task* task;
    task = [self.array_section objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = 6;
    cell.titleCell.text = task.title;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *selected = [self.tracks objectAtIndex:indexPath.row];
    //NSLog(@"selected=%@", selected);
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
