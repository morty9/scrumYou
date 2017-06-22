//
//  AddTask.m
//  Scrummary
//
//  Created by Bérangère La Touche on 14/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "AddTask.h"
#import "APIKeys.h"

@implementation AddTask

- (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category color:(NSString*)color businessValue:(NSString*)businessValue duration:(NSString*)duration id_members:(NSMutableArray*)id_member {
    
    NSURL* url = [NSURL URLWithString:kTask_api];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{
                                                     @"title" : title,
                                                     @"description" : description,
                                                     @"difficulty" : difficulty,
                                                     @"priority" : priority,
                                                     @"id_category" : id_category,
                                                     @"color" : color,
                                                     @"businessValue" : businessValue,
                                                     @"duration" : duration,
                                                     @"id_members" : id_member};
    
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
            
        }
        
    }] resume];

}

@end
