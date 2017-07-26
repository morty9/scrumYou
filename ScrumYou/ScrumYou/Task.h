//
//  Task.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject {
    NSString* _id_task;
    NSString* _title;
    NSString* _description;
    NSString* _difficulty;
    NSString* _priority;
    NSNumber* _id_category;
    NSString* _businessValue;
    NSString* _duration;
    NSString* _status;
    NSString* _id_creator;
    NSString* _taskDone;
    NSMutableArray* _id_members;
}

@property (nonatomic, strong) NSString* id_task;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* difficulty;
@property (nonatomic, strong) NSString* priority;
@property (nonatomic, strong) NSNumber* id_category;
@property (nonatomic, strong) NSString* businessValue;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* id_creator;
@property (nonatomic, strong) NSString* taskDone;
@property (nonatomic, strong) NSMutableArray* id_members;

- (instancetype) initWithId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSString*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_creator:(NSString*)id_creator taskDone:(NSString*)taskDone id_members:(NSMutableArray*)id_members;

@end
