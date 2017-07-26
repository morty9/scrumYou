//
//  CrudProjects.h
//  Scrummary
//
//  Created by Bérangère La Touche on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface CrudProjects : NSObject {
    NSMutableArray<Project*>* _projects_list;
    Project* _project;
    NSDictionary* _dict_error;
}

@property (nonatomic, strong) NSMutableArray<Project*>* projects_list;
@property (nonatomic, strong) Project* project;
@property (nonatomic, strong) NSDictionary* dict_error;

/**
 * \brief Add project to database.
 * \details Function which calls the web services projects and the method create from the projects crud.
 * \param title Title of the project.
 * \param members Members of the project.
 * \param sprints Sprints of the project.
 * \param id_creator Creator's id of the project.
 * \param token Token of the connected user.
 */
- (void) addProjecTitle:(NSString*)title members:(NSMutableArray*)members sprints:(NSMutableArray*)sprints id_creator:(NSNumber*)id_creator token:(NSString*)token status:(BOOL)status callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \brief Get all projects.
 * \details Function which calls the web services projects and the method findAll from the projects crud.
 */
- (void) getProjects:(void (^)(NSError *error, BOOL success))callback;

/**
 * \brief Get project by id.
 * \details Function which calls the web services projects and the method findOne from the projects crud.
 * \param id_project Id of the project.
 */
- (void) getProjectById:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \brief Update project.
 * \details Function which calls the web services projects and the method update from the projects crud.
 * \param id_project Id of the project.
 * \param title Title of the project.
 * \param members Members of the project.
 * \param token Token of the connected user.
 * \param id_sprints Sprints'ids of the project.
 * \param status Status of the project.
 */
- (void) updateProjectId:(NSString*)id_project title:(NSString*)title id_creator:(NSString*)id_creator members:(NSMutableArray*)members token:(NSString*)token id_sprints:(NSMutableArray*)id_sprints status:(BOOL)status callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \brief Delete project.
 * \details Function which calls the web services sprints and the method delete from the sprints crud.
 * \param id_project Id of the project.
 * \param token Token of the connected user.
 */
- (void) deleteProjectWithId:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

@end
