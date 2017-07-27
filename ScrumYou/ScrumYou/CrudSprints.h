//
//  CrudSprints.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprint.h"

@interface CrudSprints : NSObject {
    NSMutableArray<Sprint*>* _sprints_list;
    Sprint* _sprint;
    NSDictionary* _dict_error;
}

@property (nonatomic, strong) NSMutableArray<Sprint*>* sprints_list;
@property (nonatomic, strong) Sprint* sprint;
@property (nonatomic, strong) NSDictionary* dict_error;

/**
 * \fn (void) addSprintTitle:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Add sprint to database.
 * \details Function which calls the web services tasks and the method create from the tasks crud.
 * \param title Title of the sprint.
 * \param beginningDate Beginnig date of the sprint.
 * \param endDate End date of the sprint.
 * \param token Token of the connected user.
 */
- (void) addSprintTitle:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getSprints:(void (^)(NSError *error, BOOL success))callback
 * \brief Get all sprints.
 * \details Function which calls the web services sprints and the method findAll from the sprints crud.
 */
- (void) getSprints:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getSprintById:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Get sprint by id.
 * \details Function which calls the web services sprints and the method findOne from the sprints crud.
 * \param id_sprint Id of the sprint
 */
- (void) getSprintById:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) updateSprintId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate id_listTasks:(NSMutableArray*)id_listTasks token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Update sprint.
 * \details Function which calls the web services sprints and the method update from the sprints crud.
 * \param id_sprint Id of the sprint.
 * \param title Title of the sprint.
 * \param beginningDate Beginning date of the sprint.
 * \param endDate End date of the sprint.
 * \param id_listTasks List of the task's ids.
 * \param token Token of the connected user.
 */
- (void) updateSprintId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate id_listTasks:(NSMutableArray*)id_listTasks token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) deleteSprintWithId:(NSString*)id_sprint id_project:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Delete sprint.
 * \details Function which calls the web services sprints and the method delete from the sprints crud.
 * \param id_sprint Id of the sprint.
 * \param id_project Id of the project which contains the task.
 * \param token Token of the connected user.
 */
- (void) deleteSprintWithId:(NSString*)id_sprint id_project:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;


@end
