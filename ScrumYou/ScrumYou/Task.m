//
//  Task.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize id_task = _id_task;
@synthesize title = _title;
@synthesize description = _description;
@synthesize difficulty = _difficulty;
@synthesize priority = _priority;
@synthesize id_category = _id_category;
@synthesize businessValue = _businessValue;
@synthesize duration = _duration;
@synthesize status = _status;
@synthesize id_creator = _id_creator;
@synthesize taskDone = _taskDone;
@synthesize id_members = _id_members;

- (instancetype) initWithId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSString*)priority id_category:(NSString*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_creator:(NSString*)id_creator taskDone:(NSString*)taskDone id_members:(NSMutableArray*)id_members {
    
    self = [super init];
    
    if (self != nil) {
        self.id_task = id_task;
        self.title = title;
        self.description = description;
        self.difficulty = difficulty;
        self.priority = priority;
        self.id_category = id_category;
        self.businessValue = businessValue;
        self.duration = duration;
        self.status = status;
        self.id_creator = id_creator;
        self.taskDone = taskDone;
        self.id_members = id_members;
    }
    
    return self;
}

@end
