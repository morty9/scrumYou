//
//  DeleteProjects.h
//  Scrummary
//
//  Created by Bérangère La Touche on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteProjects : NSObject

- (void) deleteProjectWithId:(NSString*)id_user callback:(void (^)(NSError *error, BOOL success))callback;

@end
