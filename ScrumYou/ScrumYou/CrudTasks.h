//
//  CrudTasks.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 08/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface CrudTasks : NSObject {
    NSMutableArray<Task*>* _tasksList;
    Task* _task;
    NSDictionary* _dict_error;
}

@property (nonatomic, strong) NSMutableArray<Task*>* tasksList;
@property (nonatomic, strong) Task* task;
@property (nonatomic, strong) NSDictionary* dict_error;


/*
 *  POST -> add task to database
 */
- (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> get all tasks
 */
- (void) getTasks:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> get task by id
 */
- (void) getTaskById:(NSString*)id_task callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  UPDATE -> update task with id
 */
- (void) updateTaskId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  DELETE -> delete task by id
 */
- (void) deleteTaskWithId:(NSString*)id_task andIdSprint:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback;

@end

