//
//  UpdateProjects.h
//  Scrummary
//
//  Created by Bérangère La Touche on 04/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface UpdateProjects : NSObject

- (void) updateProjectId:(NSString*)id_project title:(NSString*)title members:(NSMutableArray*)members;

@end
