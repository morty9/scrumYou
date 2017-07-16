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

/*
 *  POST -> add sprint to database
 */
- (void) addSprintTitle:(NSString*)title beginningDate:(NSDate*)beginningDate endDate:(NSDate*)endDate callback:(void (^)(NSError *error, BOOL success))callback;

/*
 *  GET -> Get all sprints from database
 */
- (void) getSprints:(void (^)(NSError *error, BOOL success))callback;

/*
 *  GET -> get sprint by id
 */
- (void) getSprintById:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback;

/*
 * UPDATE -> update sprint with id
 */
- (void) updateSprintId:(NSString*)id_sprint endDate:(NSString*)endDate id_members:(NSMutableArray*)id_members id_listTasks:(NSMutableArray*)id_listTasks callback:(void (^)(NSError *error, BOOL success))callback;

/*
 *  DELETE -> delete sprint by id
 */
- (void) deleteSprintWithId:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback;


@end
