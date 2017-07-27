//
//  Projects.m
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize id_project = _id_project;
@synthesize title = _title;
@synthesize id_creator = _id_creator;
@synthesize id_members = _id_members;
@synthesize id_sprints = _id_sprints;
@synthesize status = _status;

/**
 * \fn (instancetype) initWithId:(NSString*)id_project title:(NSString*)title id_creator:(NSString*)id_creator id_members:(NSMutableArray*)id_members id_sprints:(NSMutableArray*)id_sprints status:(NSString*)status
 * \brief Initiation of Project model.
 * \details Allows to initialize with data an object Project.
 * \param id_project String corresponds to the id of the project.
 * \param title String corresponds to the title of the project.
 * \param id_creator String corresponds to the id creator of the project.
 * \param id_members Mutable Array corresponds to the list of all members of the project.
 * \param id_sprints Mutable Array corresponds to the list of all sprints of the project.
 * \param status String corresponds to the status of the project.
 */
- (instancetype) initWithId:(NSString*)id_project title:(NSString*)title id_creator:(NSString*)id_creator id_members:(NSMutableArray*)id_members id_sprints:(NSMutableArray*)id_sprints status:(NSString*)status {
    
    self = [super init];
    
    if (self != nil) {
        self.id_project = id_project;
        self.title = title;
        self.id_creator = id_creator;
        self.id_members = id_members;
        self.id_sprints = id_sprints;
        self.status = status;
    }
    
    return self;
}

@end
