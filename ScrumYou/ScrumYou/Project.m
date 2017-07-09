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
