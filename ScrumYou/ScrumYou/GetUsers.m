//
//  GetUsers.m
//  Scrummary
//
//  Created by Bérangère La Touche on 13/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "GetUsers.h"
#import "APIKeys.h"
#import "User.h"

@implementation GetUsers

@synthesize users_list = _users_list;

- (void) getUsers {
    self.users_list = [[NSMutableArray<User*> alloc] init];
    NSURL* url = [[NSURL alloc] initWithString:kUser_api];
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
        //dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary* user in jsonDict) {
                NSString* tmp_id = [user valueForKey:@"id"];
                NSString* tmp_nickname = [user valueForKey:@"nickname"];
                NSString* tmp_fullname = [user valueForKey:@"fullname"];
                NSString* tmp_email = [user valueForKey:@"email"];
                NSString* tmp_password = [user valueForKey:@"password"];
                NSMutableArray<NSString*>* tmp_tasks = [user valueForKey:@"id_tasks"];
            
                User* u = [[User alloc] initWithId:tmp_id nickname:tmp_nickname fullname:tmp_fullname email:tmp_email password:tmp_password id_tasks:tmp_tasks];
            
                [self.users_list addObject:u];
            }
        //});
        
    }] resume];
}

@end
