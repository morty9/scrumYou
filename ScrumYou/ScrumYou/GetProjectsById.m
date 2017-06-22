//
//  GetProjectsById.m
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "GetProjectsById.h"
#import "Project.h"
#import "APIKeys.h"

@implementation GetProjectsById

@synthesize projects_list = _projects_list;

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.projects_list = [[NSMutableArray<Project*> alloc] init];
    }
    return self;
}

//- (void) getProjectWithId:(NSString*)id_project {
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
        
        
        NSString* tmp_id = [jsonDict valueForKey:@"id"];
        NSString* tmp_title = [jsonDict valueForKey:@"title"];
        NSString* tmp_id_creator = [jsonDict valueForKey:@"id_creator"];
        NSMutableArray* tmp_id_members = [jsonDict valueForKey:@"id_members"];
        NSMutableArray* tmp_id_sprints = [jsonDict valueForKey:@"id_sprint"];
                
        Project* p = [[Project alloc] initWithId:tmp_id title:tmp_title id_creator:tmp_id_creator id_members:tmp_id_members id_sprints:tmp_id_sprints];
                
        NSLog(@"Project %@", p);
                
        [self.projects_list addObject:p];
        callback(error, true);
        
    }] resume];
    
}


@end
