//
//  SynchronousMethod.m
//  Scrummary
//
//  Created by Bérangère La Touche on 12/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "SynchronousMethod.h"

@implementation SynchronousMethod

- (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responsePtr error:(__autoreleasing NSError **)errorPtr {
    
    dispatch_semaphore_t    sem;
    __block NSData *        result;
    
    result = nil;
    
    sem = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (errorPtr != NULL) {
            *errorPtr = error;
        }
        
        if (responsePtr != NULL) {
            *responsePtr = response;
        }

        if (error == nil) {
            result = data;

        }

        dispatch_semaphore_signal(sem);

    }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return result;
}

@end
