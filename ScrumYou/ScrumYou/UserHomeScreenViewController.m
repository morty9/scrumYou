//
//  UserHomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UserHomeScreenViewController.h"
#import "CellView.h"
#import "Project.h"
#import "CrudUsers.h"
#import "CrudProjects.h"

@interface UserHomeScreenViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherCollectionView;
@property (strong, nonatomic) NSArray *tracks;
@end

@implementation UserHomeScreenViewController {
    
    NSMutableArray<Project*>* get_projects;
    
    CrudProjects* ProjectsCrud;
    
}

@synthesize collectionView = _collectionView;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        
        get_projects = [[NSMutableArray<Project*> alloc] init];
        
        ProjectsCrud = [[CrudProjects alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
    [ProjectsCrud getProjects:^(NSError *error, BOOL success) {
        if (success) {
            
        }
    }];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.otherCollectionView.delegate = self;
    self.otherCollectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
    [self.otherCollectionView registerNib:[UINib nibWithNibName:@"CellView" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    
    [self.collectionView reloadData];
    [self.otherCollectionView reloadData];
}


- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Scrummary"];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"%lu", (unsigned long)self.tracks.count);
    //return self.tracks.count;
    return 40;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString* cellId = @"Cell";
    
    CellView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.label.text = @"test";
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [self.tracks objectAtIndex:indexPath.row];
    NSLog(@"selected=%@", selected);
}

- (void) backHome {
    
}

- (void) search {
    
}

- (void) chat {
    
}

- (void) settings {
    
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
