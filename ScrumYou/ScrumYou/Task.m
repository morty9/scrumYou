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


/**
 * \fn (instancetype) initWithId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSString*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_creator:(NSString*)id_creator taskDone:(NSString*)taskDone id_members:(NSMutableArray*)id_members
 * \brief Initiation of Task model.
 * \details Allows to initialize with data an object Task.
 * \param id_task String corresponds to the id of the task.
 * \param title String corresponds to the title of the task.
 * \param description String corresponds to the description of the task.
 * \param difficulty String corresponds to the difficulty of the task.
 * \param priority String corresponds to the priority of the task.
 * \param id_category Number corresponds to the id of the category of the task.
 * \param businessValue String corresponds to the businness value of the task.
 * \param duration String corresponds to the duration of the task.
 * \param status Strinf corresponds to the status of the task.
 * \param id_creator String corresponds to the id of the creator of the task.
 * \param taskDone String corresponds to the status done of the task.
 * \param id_members Mutable Array corresponds to the lists of members of the task.
 */
- (instancetype) initWithId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSString*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_creator:(NSString*)id_creator taskDone:(NSString*)taskDone id_members:(NSMutableArray*)id_members {
    
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
