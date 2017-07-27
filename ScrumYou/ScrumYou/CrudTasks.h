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


/**
 * \fn (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSInteger)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Add task to database.
 * \details Function which calls the web services tasks and the method create from the tasks crud.
 * \param title Title of the task.
 * \param description Description of the task.
 * \param difficulty Difficulty of the task.
 * \param priority Priority of the task.
 * \param id_category Category of the task.
 * \param businessValue Business value of the task.
 * \param duration Duration of the task.
 * \param status Status of the task.
 * \param id_members Members'ids of the task.
 * \param token Token of the connected user.
 */
- (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSInteger)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getTasks:(void (^)(NSError *error, BOOL success))callback
 * \brief Get all tasks.
 * \details Function which calls the web services tasks and the method findAll from the tasks crud.
 */
- (void) getTasks:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getTaskById:(NSString*)id_task callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Get task by id.
 * \details Function which calls the web services tasks and the method findOne from the tasks crud.
 * \param id_task Id of the task
 */
- (void) getTaskById:(NSString*)id_task callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) updateTaskId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members taskDone:(NSString*)taskDone token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Update task.
 * \details Function which calls the web services tasks and the method update from the tasks crud.
 * \param id_task Id of the task.
 * \param title Title of the task.
 * \param description Description of the task.
 * \param difficulty Difficulty of the task.
 * \param priority Priority of the task.
 * \param id_category Category of the task.
 * \param businessValue Business value of the task.
 * \param duration Duration of the task.
 * \param status Status of the task.
 * \param id_members Members'ids of the task.
 * \param taskDone If the task is done, get the end date.
 * \param token Token of the connected user.
 */
- (void) updateTaskId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members taskDone:(NSString*)taskDone token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) deleteTaskWithId:(NSString*)id_task andIdSprint:(NSString*)id_sprint token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Delete task.
 * \details Function which calls the web services tasks and the method delete from the tasks crud.
 * \param id_task Id of the task.
 * \param id_sprint Id of the sprint which contains the task.
 * \param token Token of the connected user.
 */
- (void) deleteTaskWithId:(NSString*)id_task andIdSprint:(NSString*)id_sprint token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

@end

