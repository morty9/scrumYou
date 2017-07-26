//
//  ScrumBoardCell.h
//  Scrummary
//
//  Created by Bérangère La Touche on 09/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrumBoardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleCell;
@property (weak, nonatomic) IBOutlet UITextView *descriptionCell;
@property (weak, nonatomic) IBOutlet UILabel *priorityCell;
@property (weak, nonatomic) IBOutlet UILabel *categoryCell;
@property (weak, nonatomic) IBOutlet UILabel *membersCell;
@property (weak, nonatomic) IBOutlet UIButton *pencil;

@end
