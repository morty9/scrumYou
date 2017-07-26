//
//  CrudSprints.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CrudSprints.h"
#import "APIKeys.h"
#import "Sprint.h"
#import "SynchronousMethod.h"

@implementation CrudSprints {
    SynchronousMethod* synchronousMethod;
}

@synthesize  sprint = _sprint;

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.sprints_list = [[NSMutableArray<Sprint*> alloc] init];
        self.sprint = [[Sprint alloc] init];
        synchronousMethod = [[SynchronousMethod alloc] init];
    }
    
    return self;
}


/**
 * \brief Add sprint to database.
 * \details Function which calls the web services tasks and the method create from the tasks crud.
 * \param title Title of the sprint.
 * \param beginningDate Beginnig date of the sprint.
 * \param endDate End date of the sprint.
 * \param token Token of the connected user.
 */
- (void) addSprintTitle:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL* url = [NSURL URLWithString:kSprint_api];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary* jsonData = @{@"title" : title,
                               @"beginningDate" : beginningDate,
                               @"endDate" : endDate};
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        if (data == nil) {
            return;
        }
        
        if (response == nil) {
            return;
        }
        
        if ([jsonDict valueForKey:@"type"] != nil) {
            _dict_error = jsonDict;
        }
        
        NSString* tmp_id = [jsonDict valueForKey:@"id"];
        NSString* tmp_title = [jsonDict valueForKey:@"title"];
        NSString* tmp_beginningDate = [jsonDict valueForKey:@"beginningDate"];
        NSDate* tmp_endDate = [jsonDict valueForKey:@"endDate"];
        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
        NSMutableArray* tmp_id_listTasks = [jsonDict valueForKey:@"id_listTasks"];
        
        self.sprint = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks];
        
        callback(error, true);
        
    }] resume];
    
}


/**
 * \brief Get all sprints.
 * \details Function which calls the web services sprints and the method findAll from the sprints crud.
 */
- (void) getSprints:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL* url = [NSURL URLWithString:kSprint_api];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [synchronousMethod sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        for (NSDictionary* sprint in jsonDict) {
            NSString* tmp_id = [sprint valueForKey:@"id"];
            NSString* tmp_title = [sprint valueForKey:@"title"];
            NSString* tmp_beginningDate = [sprint valueForKey:@"beginningDate"];
            NSDate* tmp_endDate = [sprint valueForKey:@"endDate"];
            NSString* tmp_id_creator = [sprint valueForKey:@"id_creator"];
            NSMutableArray* tmp_id_listTasks = [sprint valueForKey:@"id_listTasks"];
            
            Sprint* s = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks];
            
            [self.sprints_list addObject:s];
        }
        
        callback(error, true);
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
}


/**
 * \brief Get sprint by id.
 * \details Function which calls the web services sprints and the method findOne from the sprints crud.
 * \param id_sprint Id of the sprint
 */
- (void) getSprintById:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kSprint_api stringByAppendingString:[@"/" stringByAppendingString:id_sprint]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [synchronousMethod sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(data){
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSString* tmp_id = [jsonDict valueForKey:@"id"];
        NSString* tmp_title = [jsonDict valueForKey:@"title"];
        NSString* tmp_beginningDate = [jsonDict valueForKey:@"beginningDate"];
        NSDate* tmp_endDate = [jsonDict valueForKey:@"endDate"];
        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
        NSMutableArray* tmp_id_listTasks = [jsonDict valueForKey:@"id_listTasks"];
        
        self.sprint = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks];
        
        NSLog(@"Sprint %@", self.sprint);
        
        callback(error, true);
    }
    else{
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
}

/**
 * \brief Update sprint.
 * \details Function which calls the web services sprints and the method update from the sprints crud.
 * \param id_sprint Id of the sprint.
 * \param title Title of the sprint.
 * \param beginningDate Beginning date of the sprint.
 * \param endDate End date of the sprint.
 * \param id_listTasks List of the task's ids.
 * \param token Token of the connected user.
 */
- (void) updateSprintId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate id_listTasks:(NSMutableArray*)id_listTasks token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kSprint_api stringByAppendingString:[@"/" stringByAppendingString:id_sprint]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"id" : id_sprint,
                                                     @"title" : title,
                                                     @"beginningDate" : beginningDate,
                                                     @"endDate" : endDate,
                                                     @"id_listTasks" : id_listTasks};
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        if (data == nil) {
            return;
        }
        
        if (response == nil) {
            return;
        }
        
        callback(error, true);
        
    }] resume];
    
}


/**
 * \brief Delete sprint.
 * \details Function which calls the web services sprints and the method delete from the sprints crud.
 * \param id_sprint Id of the sprint.
 * \param id_project Id of the project which contains the task.
 * \param token Token of the connected user.
 */
- (void) deleteSprintWithId:(NSString*)id_sprint id_project:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSLog(@"id_sprint %@", id_sprint);
    NSLog(@"kSprint_API %@", kSprint_api);
    
    NSURL* url = [NSURL URLWithString:[kSprint_api stringByAppendingString:[@"/" stringByAppendingString:[id_sprint stringByAppendingString:[@"/" stringByAppendingString:id_project]]]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        if (data == nil) {
            return;
        }
        
        if (response == nil) {
            return;
        }
        
        callback(error, true);
        
    }] resume];
    
}

@end
