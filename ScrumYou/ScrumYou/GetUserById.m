//
//  GetUserById.m
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "GetUserById.h"
#import "APIKeys.h"
#import "User.h"

@implementation GetUserById

@synthesize usersList = usersList;

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        usersList = [[NSMutableArray<User*> alloc] init];
    }
    return self;
}

- (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback {
    NSURL *url = [NSURL URLWithString:[kUser_api stringByAppendingString:userId]];
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
        NSString* tmp_nickname = [jsonDict valueForKey:@"nickname"];
        NSString* tmp_fullname = [jsonDict valueForKey:@"fullname"];
        NSString* tmp_email = [jsonDict valueForKey:@"email"];
        NSString* tmp_password = [jsonDict valueForKey:@"password"];
        NSMutableArray* tmp_id_tasks = [jsonDict valueForKey:@"id_tasks"];
            
        User* u = [[User alloc] initWithId:tmp_id nickname:tmp_nickname fullname:tmp_fullname email:tmp_email password:tmp_password id_tasks:tmp_id_tasks];
            
        
        NSLog(@"User %@", u);
        
        [usersList addObject:u];
        
        callback(error, true);
        
    }]resume];
    
}

@end
