//
//  PageContentViewController.h
//  Scrummary
//
//  Created by Bérangère La Touche on 20/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface PageContentViewController : UIViewController {
    NSDictionary* _dictionary_section;
    NSArray<Task*>* _array_section;
}

@property (nonatomic, strong) NSDictionary* dictionary_section;
@property (nonatomic, strong) NSArray* array_section;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UICollectionView *scrumBoardCollectionView;

@property NSUInteger pageIndex;
@property NSString *txtTitle;

@end
