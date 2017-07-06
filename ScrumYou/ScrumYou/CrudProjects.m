//
//  CrudProjects.m
//  Scrummary
//
//  Created by Bérangère La Touche on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CrudProjects.h"
#import "APIKeys.h"
#import "Project.h"

@implementation CrudProjects

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.projects_list = [[NSMutableArray<Project*> alloc] init];
    }
    return self;
}


/*
 *  POST -> add project to database
 */
- (void) addProjecTitle:(NSString*)title members:(NSMutableArray*)members {
    
    NSURL *url = [NSURL URLWithString:kProject_api];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary<NSString*, NSString*> *jsonData =
    @{@"title" : title,
      @"id_members" : members};
    
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
        
    }] resume];
}


/*
 *  GET -> get project by id
 */
- (void) getProjectById:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kProject_api stringByAppendingString:[@"/" stringByAppendingString:id_project]]];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* tmp_id = [jsonDict valueForKey:@"id"];
            NSString* tmp_title = [jsonDict valueForKey:@"title"];
            NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
            NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
            NSMutableArray* tmp_id_sprints = [jsonDict valueForKey:@"id_sprint"];
            
            Project* p = [[Project alloc] initWithId:tmp_id title:tmp_title id_creator:tmp_id_creator id_members:tmp_id_members id_sprints:tmp_id_sprints];
            
            NSLog(@"Project WS %@", p);
            
            [self.projects_list addObject:p];
            callback(error, true);
        });
        
    }] resume];
    
}

/*
 * UPDATE -> update project with id
 */
- (void) updateProjectId:(NSString*)id_project title:(NSString*)title members:(NSMutableArray*)members {
    
    NSURL *url = [NSURL URLWithString:[kProject_api stringByAppendingString:[@"/" stringByAppendingString:id_project]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"title" : title, @"id_members" : members};
    
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
        
    }] resume];
    
}


/*
 *  DELETE -> delete project by id
 */
- (void) deleteProjectWithId:(NSString*)id_project callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL* url = [[NSURL alloc] initWithString:kProject_api];
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
