//
//  Stat.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Stat.h"

@implementation Stat

@synthesize id_stats = _id_stats;
@synthesize id_listTasks = _id_listTasks;
@synthesize sprintDuration = _sprintDuration;
@synthesize beginningDateProject = _beginningDateProject;


- (instancetype) initWithId:(NSString*)id_stats id_listTasks:(NSMutableArray*)id_listTasks sprintDuration:(NSString*)sprintDuration beginningDateProject:(NSString*)beginningDateProject {
    
    self = [super init];
    
    if (self != nil) {
        self.id_stats = id_stats;
        self.id_listTasks = id_listTasks;
        self.sprintDuration = sprintDuration;
        self.beginningDateProject = beginningDateProject;
    }
    
    return self;
    
}

@end
