//
//  CrudAuth.h
//  Scrummary
//
//  Created by Bérangère La Touche on 08/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrudAuth : NSObject {
    NSDictionary* _token;
}

@property (nonatomic, strong) NSDictionary* token;

- (void) login:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback;

- (void) logout:(NSString*)tokenId tokenToken:(NSString*)tokenToken callback:(void (^)(NSError *error, BOOL success))callback;

@end
