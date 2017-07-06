
//
//  UpdateProjects.m
//  Scrummary
//
//  Created by Bérangère La Touche on 04/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "UpdateProjects.h"
#import "APIKeys.h"

@implementation UpdateProjects

- (void) updateProjectId:(NSString*)id_project title:(NSString*)title members:(NSMutableArray*)members {
    
    NSURL *url = [NSURL URLWithString:kProject_api];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    //NSDictionary<NSString*, NSString*> *jsonData = @{@"title" : title};
    NSString* jsonString = @"{\"id\":\"1\",\"title\":\"helloa\",\"id_members\":921}";
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
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

@end
