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
}

@property (nonatomic, strong) NSMutableArray<Project*>* projects_list;

- (void) addProjecTitle:(NSString*)title members:(NSMutableArray*)members;
- (void) getProjectById:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback;
- (void) updateProjectId:(NSString*)id_project title:(NSString*)title members:(NSMutableArray*)members;
- (void) deleteProjectWithId:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback;

@end
