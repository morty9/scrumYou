//
//  UserHomeScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface UserHomeScreenViewController : UIViewController
{
    NSMutableArray<Data*>* _dataArray;
}

@property (nonatomic, strong) NSMutableArray<Data*>* dataArray;

- (void) backHome;

- (void) search;

- (void) chat;

- (void) settings;

@end
