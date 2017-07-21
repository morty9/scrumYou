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


/*
 *  POST -> add sprint to database
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
        NSString* tmp_endDate = [jsonDict valueForKey:@"endDate"];
        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
        NSMutableArray* tmp_id_listTasks = [jsonDict valueForKey:@"id_listTasks"];
        NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
        
        self.sprint = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks id_members:tmp_id_members];
        
        callback(error, true);
        
    }] resume];
    
}


/*
 *  GET -> Get all sprints from database
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
            NSString* tmp_endDate = [sprint valueForKey:@"endDate"];
            NSString* tmp_id_creator = [sprint valueForKey:@"id_creator"];
            NSMutableArray* tmp_id_listTasks = [sprint valueForKey:@"id_listTasks"];
            NSMutableArray* tmp_id_members = [sprint valueForKey:@"id_members"];
            
            Sprint* s = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks id_members:tmp_id_members];
            
            [self.sprints_list addObject:s];
        }
        
        callback(error, true);
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
}


/*
 *  GET -> get sprint by id
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
        NSString* tmp_endDate = [jsonDict valueForKey:@"endDate"];
        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
        NSMutableArray* tmp_id_listTasks = [jsonDict valueForKey:@"id_listTasks"];
        NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
        
        self.sprint = [[Sprint alloc] initWithId:tmp_id title:tmp_title beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks id_members:tmp_id_members];
        
        NSLog(@"Sprint %@", self.sprint);
        
        callback(error, true);
    }
    else{
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
//        
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//            return;
//        }
//        
//        if (data == nil) {
//            return;
//        }
//        
//        if (response == nil) {
//            return;
//        }
//        
//        //dispatch_async(dispatch_get_main_queue(), ^{
//            NSString* tmp_id = [jsonDict valueForKey:@"id"];
//            NSString* tmp_beginningDate = [jsonDict valueForKey:@"beginningDate"];
//            NSString* tmp_endDate = [jsonDict valueForKey:@"endDate"];
//            NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
//            NSMutableArray* tmp_id_listTasks = [jsonDict valueForKey:@"id_listTasks"];
//            NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
//            
//            self.sprint = [[Sprint alloc] initWithId:tmp_id beginningDate:tmp_beginningDate endDate:tmp_endDate id_creator:tmp_id_creator id_listTasks:tmp_id_listTasks id_members:tmp_id_members];
//            
//            NSLog(@"Sprint WS %@", self.sprint);
//            
//            callback(error, true);
//        //});
//        
//    }] resume];

    
}

/*
 * UPDATE -> update sprint with id
 */
- (void) updateSprintId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSString*)endDate id_members:(NSMutableArray*)id_members id_listTasks:(NSMutableArray*)id_listTasks token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSLog(@"ID_SPRINT %@", id_sprint);
    NSLog(@"TITLE %@", title);
    NSLog(@"BEGINNING DATE %@", beginningDate);
    NSLog(@"END DATE %@", endDate);
    NSLog(@"MEMBERS %@", id_members);
    NSLog(@"TASKS %@", id_listTasks);
    
    NSURL *url = [NSURL URLWithString:[kSprint_api stringByAppendingString:[@"/" stringByAppendingString:id_sprint]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"id" : id_sprint,
                                                     @"title" : title,
                                                     @"beginningDate" : beginningDate,
                                                     @"endDate" : endDate,
                                                     @"id_members" : id_members,
                                                     @"id_listTasks" : id_listTasks};
    
    NSLog(@"JSON DATA %@", jsonData);
    
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


/*
 *  DELETE -> delete sprint by id
 */
- (void) deleteSprintWithId:(NSString*)id_sprint token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL* url = [NSURL URLWithString:[kSprint_api stringByAppendingString:[@"/" stringByAppendingString:id_sprint]]];
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
