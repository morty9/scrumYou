//
//  Stat.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stat : NSObject {
    NSString* _id_stats;
    NSMutableArray* _id_listTasks;
    NSString* _sprintDuration;
    NSString* _beginningDateProject;
}

@property (nonatomic, strong) NSString* id_stats;
@property (nonatomic, strong) NSMutableArray* id_listTasks;
@property (nonatomic, strong) NSString* sprintDuration;
@property (nonatomic, strong) NSString* beginningDateProject;

- (instancetype) initWithId:(NSString*)id_stats id_listTasks:(NSMutableArray*)id_listTasks sprintDuration:(NSString*)sprintDuration beginningDateProject:(NSString*)beginningDateProject;

@end
