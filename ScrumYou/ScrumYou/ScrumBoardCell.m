//
//  ScrumBoardCell.m
//  Scrummary
//
//  Created by Bérangère La Touche on 09/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ScrumBoardCell.h"

@implementation ScrumBoardCell

@synthesize titleCell = _titleCell;
@synthesize descriptionCell = _descriptionCell;
@synthesize priorityCell = _priorityCell;
@synthesize categoryCell = _categoryCell;
@synthesize membersCell = _membersCell;
@synthesize pencil = _pencil;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
