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

/*
 *  POST -> add project to database
 */
- (void) addProjecTitle:(NSString*)title members:(NSMutableArray*)members id_creator:(NSNumber*)id_creator callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> Get all projects from database
 */
- (void) getProjects:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> get project by id
 */
- (void) getProjectById:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback;
/*
 * UPDATE -> update project with id
 */
- (void) updateProjectId:(NSString*)id_project title:(NSString*)title members:(NSMutableArray*)members token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  DELETE -> delete project by id
 */
- (void) deleteProjectWithId:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

@end
