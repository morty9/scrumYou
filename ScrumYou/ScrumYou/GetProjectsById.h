//
//  GetProjectsById.h
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface GetProjectsById : NSObject {
    NSMutableArray<Project*>* _projects_list;
}

@property (nonatomic, strong) NSMutableArray<Project*>* projects_list;

//- (void) getProjectWithId:(NSString*)id_project;
- (void) getProjectById:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback;

@end
