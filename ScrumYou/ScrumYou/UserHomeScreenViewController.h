//
//  UserHomeScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHomeScreenViewController : UIViewController
{
    NSDictionary* _token;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherCollectionView;
@property (strong, nonatomic) NSArray *tracks;
@property (nonatomic, strong) NSDictionary* token;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
