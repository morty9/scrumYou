//
//  UserHomeScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHomeScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherCollectionView;
@property (strong, nonatomic) NSArray *tracks;


- (void) backHome;

- (void) search;

- (void) chat;

- (void) settings;

@end
