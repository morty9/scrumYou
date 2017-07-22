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
@synthesize id_project = _id_project;


- (instancetype) initWithId:(NSString*)id_stats id_project:(NSString*)id_project {
    
    self = [super init];
    
    if (self != nil) {
        self.id_stats = id_stats;
        self.id_project = id_project;
    }
    
    return self;
    
}

@end
