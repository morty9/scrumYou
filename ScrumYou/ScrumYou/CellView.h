//
//  CellView.h
//  Scrummary
//
//  Created by Bérangère La Touche on 18/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UICollectionViewCell
{
    
    __weak IBOutlet UIButton *buttonStats;
    
}

@property (nonatomic, weak) IBOutlet UILabel* label;
@property (weak, nonatomic) IBOutlet UILabel *nSprint;
@property (weak, nonatomic) IBOutlet UILabel *nTaskTodo;
@property (weak, nonatomic) IBOutlet UILabel *nTaskProgress;
@property (weak, nonatomic) IBOutlet UILabel *nTaskDone;
@property (weak, nonatomic) IBOutlet UIButton *buttonStats;

@end
