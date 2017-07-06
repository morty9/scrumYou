
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

- (void) updateProjectTitle:(NSString*)title members:(NSMutableArray*)members {
    
    NSURL *url = [NSURL URLWithString:kProject_api];
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

@end
