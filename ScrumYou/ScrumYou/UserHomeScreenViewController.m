//
//  UserHomeScreenViewController.m
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UserHomeScreenViewController.h"
#import "CellView.h"

@interface UserHomeScreenViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *tracks;
@end

@implementation UserHomeScreenViewController

@synthesize collectionView = _collectionView;
@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designPage];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tracks = @[@"foo", @"bar", @"baz"];
    [self.collectionView reloadData];
}

- (void) designPage {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Scrummary"];
    
    //[self addCustomToolBar];
}

- (void) addCustomToolBar {
//    UIToolbar* toolBar = [[UIToolbar alloc] init];
//    toolBar.barTintColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
//    [toolBar setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 55)];
//    
//    UIImage *backHome = [[UIImage imageNamed:@"mini-logo-toolbar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backHomeButton = [[UIBarButtonItem alloc] initWithImage:backHome style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
//    
//    UIImage *search = [[UIImage imageNamed:@"search-toolbar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
//    
//    UIImage *chat = [[UIImage imageNamed:@"chat-toolbar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:chat style:UIBarButtonItemStylePlain target:self action:@selector(chat:)];
//    
//    UIImage *settings = [[UIImage imageNamed:@"settings-toolbar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:settings style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];
//    
//    NSArray* items = [NSArray arrayWithObjects:backHomeButton, searchButton, chatButton, settingsButton, nil];
//    
//    toolBar.items = items;
//    
//    [self.view addSubview:toolBar];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.tracks.count);
    return self.tracks.count;
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
