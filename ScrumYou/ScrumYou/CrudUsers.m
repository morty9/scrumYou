//
//  CrudUsers.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CrudUsers.h"
#import "APIKeys.h"
#import "User.h"

@implementation CrudUsers

@synthesize dict_error = _dict_error;

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.userList = [[NSMutableArray<User*> alloc] init];
        self.user = [[User alloc] init];
        self.dict_error = [[NSDictionary alloc] init];
    }
    return self;
}


/*
 *  POST -> add user to database
 */
- (void) addNickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback {
    
    self.dict_error = [[NSDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:kUser_api];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"nickname" : nickname,
                                                     @"fullname" : fullname,
                                                     @"email" : email,
                                                     @"password" : password};
    
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
 *  GET -> get all users
 */
- (void) getUsers:(void (^)(NSError *error, BOOL success))callback {
    
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
        
        for (NSDictionary* user in jsonDict) {
            NSString* tmp_id = [user valueForKey:@"id"];
            NSString* tmp_nickname = [user valueForKey:@"nickname"];
            NSString* tmp_fullname = [user valueForKey:@"fullname"];
            NSString* tmp_email = [user valueForKey:@"email"];
            NSString* tmp_password = [user valueForKey:@"password"];
            NSMutableArray<NSString*>* tmp_tasks = [user valueForKey:@"id_tasks"];
            
            User* u = [[User alloc] initWithId:tmp_id nickname:tmp_nickname fullname:tmp_fullname email:tmp_email password:tmp_password id_tasks:tmp_tasks];
            
            [self.userList addObject:u];
        }
        
    }] resume];
    
}


/*
 *  GET -> get user by id
 */
- (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kUser_api stringByAppendingString:[@"/" stringByAppendingString:userId]]];
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
            NSString* tmp_nickname = [jsonDict valueForKey:@"nickname"];
            NSString* tmp_fullname = [jsonDict valueForKey:@"fullname"];
            NSString* tmp_email = [jsonDict valueForKey:@"email"];
            NSString* tmp_password = [jsonDict valueForKey:@"password"];
            NSMutableArray* tmp_id_tasks = [jsonDict valueForKey:@"id_tasks"];
            
            self.user = [[User alloc] initWithId:tmp_id nickname:tmp_nickname fullname:tmp_fullname email:tmp_email password:tmp_password id_tasks:tmp_id_tasks];
            
            
            NSLog(@"User %@", self.user);
            
            callback(error, true);
            
        });
        
    }]resume];
    
}


/*
 *  UPDATE -> update user with id
 */
- (void) updateUserId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
    
    NSURL *url = [NSURL URLWithString:[kUser_api stringByAppendingString:[@"/" stringByAppendingString:id_user]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary<NSString*, NSString*> *jsonData = @{@"nickname" : nickname,
                                                     @"fullname" : fullname,
                                                     @"email"  : email,
                                                     @"password" : password};
    
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
 *  DELETE -> delete user by id
 */
- (void) deleteUserWithId:(NSString*)id_user token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback {
 
    NSURL* url = [NSURL URLWithString:[kUser_api stringByAppendingString:[@"/" stringByAppendingString:id_user]]];
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
