//
//  Sprint.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Sprint.h"

@implementation Sprint

@synthesize id_sprint = _id_sprint;
@synthesize title = _title;
@synthesize beginningDate = _beginningDate;
@synthesize endDate = _endDate;
@synthesize id_creator = _id_creator;
@synthesize id_listTasks = _id_listTasks;


/**
 * \fn (instancetype) initWithId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSDate*)endDate id_creator:(NSString*)id_creator id_listTasks:(NSMutableArray*)id_listTasks
 * \brief Initiation of Sprint model.
 * \details Allows to initialize with data an object Sprint.
 * \param id_sprint String corresponds to the id of the sprint.
 * \param title String corresponds to the title of the sprint.
 * \param beginningDate String corresponds to the beginningDate of the sprint.
 * \param endDate Date corresponds to the endDate of the sprint.
 * \param id_creator String corresponds to the id creator of the sprint.
 * \param id_listTasks Mutable Array corresponds to the lists of tasks of the sprint.
 */
- (instancetype) initWithId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSDate*)endDate id_creator:(NSString*)id_creator id_listTasks:(NSMutableArray*)id_listTasks {
    
    self = [super init];
    
    if (self != nil) {
        self.id_sprint = id_sprint;
        self.title = title;
        self.beginningDate = beginningDate;
        self.endDate = endDate;
        self.id_creator = id_creator;
        self.id_listTasks = id_listTasks;
    }
    
    return self;
    
}

@end
