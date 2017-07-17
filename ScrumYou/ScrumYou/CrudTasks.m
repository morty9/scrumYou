//
//  CrudTasks.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 08/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CrudTasks.h"
#import "APIKeys.h"
#import "Task.h"
#import "SynchronousMethod.h"

@implementation CrudTasks {
    SynchronousMethod* synchronousMethod;
}

@synthesize task = _task;
@synthesize dict_error = _dict_error;

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.tasksList = [[NSMutableArray<Task*> alloc] init];
        self.task = [[Task alloc] init];
        synchronousMethod = [[SynchronousMethod alloc] init];
    }
    
    return self;
}

/*
 *  POST -> add task to database
 */
- (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members callback:(void (^)(NSError *error, BOOL success))callback {
    
    self.dict_error = [[NSDictionary alloc] init];
    
    NSURL* url = [NSURL URLWithString:kTask_api];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"title" : title,
                                                     @"description" : description,
                                                     @"difficulty" : difficulty,
                                                     @"priority" : priority,
                                                     @"id_category" : id_category,
                                                     @"businessValue" : businessValue,
                                                     @"duration" : duration,
                                                     @"status" : status,
                                                     @"id_members" : id_members};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [synchronousMethod sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(data){
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if ([jsonDict valueForKey:@"type"] != nil) {
            _dict_error = jsonDict;
        } else {
            NSString* tmp_id = [jsonDict valueForKey:@"id"];
            NSString* tmp_title = [jsonDict valueForKey:@"title"];
            NSString* tmp_description = [jsonDict valueForKey:@"description"];
            NSString* tmp_difficulty = [jsonDict valueForKey:@"difficulty"];
            NSString* tmp_priority = [jsonDict valueForKey:@"priority"];
            NSString* tmp_id_category = [jsonDict valueForKey:@"id_category"];
            NSString* tmp_businessValue = [jsonDict valueForKey:@"businessValue"];
            NSString* tmp_duration = [jsonDict valueForKey:@"duration"];
            NSString* tmp_status = [jsonDict valueForKey:@"status"];
            NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
            NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
            
            Task* t = [[Task alloc] initWithId:tmp_id title:tmp_title description:tmp_description difficulty:tmp_difficulty priority:tmp_priority id_category:tmp_id_category businessValue:tmp_businessValue duration:tmp_duration status:tmp_status id_creator:tmp_id_creator id_members:tmp_id_members];
            
            self.task = t;
        }
                    
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
//        if ([jsonDict valueForKey:@"type"] != nil) {
//            _dict_error = jsonDict;
//        }
//        
//        NSString* tmp_id = [jsonDict valueForKey:@"id"];
//        NSString* tmp_title = [jsonDict valueForKey:@"title"];
//        NSString* tmp_description = [jsonDict valueForKey:@"description"];
//        NSString* tmp_difficulty = [jsonDict valueForKey:@"difficulty"];
//        NSString* tmp_priority = [jsonDict valueForKey:@"priority"];
//        NSString* tmp_id_category = [jsonDict valueForKey:@"id_category"];
//        NSString* tmp_businessValue = [jsonDict valueForKey:@"businessValue"];
//        NSString* tmp_duration = [jsonDict valueForKey:@"duration"];
//        NSString* tmp_status = [jsonDict valueForKey:@"status"];
//        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
//        NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
//        
//        Task* t = [[Task alloc] initWithId:tmp_id title:tmp_title description:tmp_description difficulty:tmp_difficulty priority:tmp_priority id_category:tmp_id_category businessValue:tmp_businessValue duration:tmp_duration status:tmp_status id_creator:tmp_id_creator id_members:tmp_id_members];
//        
//        self.task = t;
//        
//        callback(error, true);
//        
//    }] resume];

}


/*
 *  GET -> get all tasks
 */
- (void) getTasks:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL* url = [NSURL URLWithString:kTask_api];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary* tasks in jsonDict) {
                NSString* tmp_id = [tasks valueForKey:@"id"];
                NSString* tmp_title = [tasks valueForKey:@"title"];
                NSString* tmp_description = [tasks valueForKey:@"description"];
                NSString* tmp_difficulty = [tasks valueForKey:@"difficulty"];
                NSString* tmp_priority = [tasks valueForKey:@"priority"];
                NSString* tmp_id_category = [tasks valueForKey:@"id_category"];
                NSString* tmp_businessValue = [tasks valueForKey:@"businessValue"];
                NSString* tmp_duration = [tasks valueForKey:@"duration"];
                NSString* tmp_status = [tasks valueForKey:@"status"];
                NSString* tmp_id_creator = [tasks valueForKey:@"id_creator"];

                NSMutableArray* tmp_id_members = [tasks valueForKey:@"id_members"];
                
                Task* t = [[Task alloc] initWithId:tmp_id title:tmp_title description:tmp_description difficulty:tmp_difficulty priority:tmp_priority id_category:tmp_id_category businessValue:tmp_businessValue duration:tmp_duration status:tmp_status id_creator:tmp_id_creator id_members:tmp_id_members];
                
                [self.tasksList addObject:t];

            }
            
            callback(error, true);
        });
        
    }] resume];
    
}


/*
 *  GET -> get task by id
 */
- (void) getTaskById:(NSString*)id_task callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kTask_api stringByAppendingString:[@"/" stringByAppendingString:id_task]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [synchronousMethod sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(data){
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if ([jsonDict valueForKey:@"type"] != nil) {
            _dict_error = jsonDict;
        } else {
            NSString* tmp_id = [jsonDict valueForKey:@"id"];
            NSString* tmp_title = [jsonDict valueForKey:@"title"];
            NSString* tmp_description = [jsonDict valueForKey:@"description"];
            NSString* tmp_difficulty = [jsonDict valueForKey:@"difficulty"];
            NSString* tmp_priority = [jsonDict valueForKey:@"priority"];
            NSString* tmp_id_category = [jsonDict valueForKey:@"id_category"];
            NSString* tmp_businessValue = [jsonDict valueForKey:@"businessValue"];
            NSString* tmp_duration = [jsonDict valueForKey:@"duration"];
            NSString* tmp_status = [jsonDict valueForKey:@"status"];
            NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
            NSMutableArray<NSString*>* tmp_id_members = [jsonDict valueForKey:@"id_members"];
            
            self.task = [[Task alloc] initWithId:tmp_id title:tmp_title description:tmp_description difficulty:tmp_difficulty priority:tmp_priority id_category:tmp_id_category businessValue:tmp_businessValue duration:tmp_duration status:tmp_status id_creator:tmp_id_creator id_members:tmp_id_members];

        }
        
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
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString* tmp_id = [jsonDict valueForKey:@"id"];
//            NSString* tmp_title = [jsonDict valueForKey:@"title"];
//            NSString* tmp_description = [jsonDict valueForKey:@"description"];
//            NSString* tmp_difficulty = [jsonDict valueForKey:@"difficuty"];
//            NSString* tmp_priority = [jsonDict valueForKey:@"priority"];
//            NSString* tmp_id_category = [jsonDict valueForKey:@"id_category"];
//            NSString* tmp_color = [jsonDict valueForKey:@"color"];
//            NSString* tmp_businessValue = [jsonDict valueForKey:@"businessValue"];
//            NSString* tmp_duration = [jsonDict valueForKey:@"duration"];
//            NSString* tmp_status = [jsonDict valueForKey:@"status"];
//            NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
//            NSMutableArray<NSString*>* tmp_id_members = [jsonDict valueForKey:@"id_members"];
//            
//            self.task = [[Task alloc] initWithId:tmp_id title:tmp_title description:tmp_description difficulty:tmp_difficulty priority:tmp_priority id_category:tmp_id_category color:tmp_color businessValue:tmp_businessValue duration:tmp_duration status:tmp_status id_creator:tmp_id_creator id_members:tmp_id_members];
//            
//            callback(error, true);
//        });
//        
//    }] resume];

    
}


/*
 *  UPDATE -> update task with id
 */
- (void) updateTaskId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_members:(NSMutableArray*)id_members callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kTask_api stringByAppendingString:[@"/" stringByAppendingString:id_task]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"id_task" : id_task,
                                                     @"title" : title,
                                                     @"description" : description,
                                                     @"difficulty" : difficulty,
                                                     @"priority" : priority,
                                                     @"id_category" : id_category,
                                                     @"businessValue" : businessValue,
                                                     @"duration" : duration,
                                                     @"status" : status,
                                                     @"id_members" : id_members};
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
        
        callback(error, true);
        
    }] resume];
    
}


/*
 *  DELETE -> delete task by id
 */
- (void) deleteTaskWithId:(NSString*)id_task andIdSprint:(NSString*)id_sprint callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSString* extensionUrl = [@"/" stringByAppendingString:[id_task stringByAppendingString:[@"/" stringByAppendingString:id_sprint]]];
    NSLog(@"URL EXT %@", extensionUrl);
    NSURL* url = [NSURL URLWithString:[kTask_api stringByAppendingString:extensionUrl]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
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










