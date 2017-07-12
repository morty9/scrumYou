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
@synthesize id_members = _id_members;

- (instancetype) initWithId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate id_creator:(NSString*)id_creator id_listTasks:(NSMutableArray*)id_listTasks id_members:(NSMutableArray*)id_members {
    
    self = [super init];
    
    if (self != nil) {
        self.id_sprint = id_sprint;
        self.title = title;
        self.beginningDate = beginningDate;
        self.endDate = endDate;
        self.id_creator = id_creator;
        self.id_listTasks = id_listTasks;
        self.id_members = id_members;
    }
    
    return self;
    
}

@end
