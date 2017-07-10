//
//  CellView.m
//  Scrummary
//
//  Created by Bérangère La Touche on 18/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CellView.h"

@implementation CellView

@synthesize label = label_;
@synthesize nSprint = _nSprint;
@synthesize nTaskTodo = _nTaskTodo;
@synthesize nTaskProgress = _nTaskProgress;
@synthesize nTaskDone = _nTaskDone;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
