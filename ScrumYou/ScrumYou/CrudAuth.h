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
    NSDictionary* _dict_error;
}

@property (nonatomic, strong) NSDictionary* token;
@property (nonatomic, strong) NSDictionary* dict_error;

/**
 * \brief Allow to login of the application.
 * \details Function which calls the web services auth and the method login.
 * \param email Email of the user.
 * \param password Password of the user.
 */
- (void) login:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \brief Allow to logout of the application.
 * \details Function which calls the web services auth and the method logout.
 * \param tokenId Id of the token.
 * \param tokenToken Token of the connected user.
 */
- (void) logout:(NSString*)tokenId tokenToken:(NSString*)tokenToken callback:(void (^)(NSError *error, BOOL success))callback;

@end
