//
//  CrudUsers.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CrudUsers : NSObject {
    NSMutableArray<User*>* _userList;
    NSDictionary* _dict_error;
    User* _user;
}

@property (nonatomic, strong) NSMutableArray<User*>* userList;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSDictionary* dict_error;


/**
 * \fn (void) addNickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Add user to database.
 * \details Function which calls the web services users and the method create from the users crud.
 * \param nickname Nickname of the user.
 * \param fullname Fullname of the user.
 * \param email Email of the user.
 * \param password Password of the user.
 */
- (void) addNickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getUsers:(void (^)(NSError *error, BOOL success))callback
 * \brief Get all users.
 * \details Function which calls the web services users and the method findAll from the users crud.
 */
- (void) getUsers:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Get user by id.
 * \details Function which calls the web services users and the method findOne from the users crud.
 * \param userId Id of the user.
 */
- (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) updateUserId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Update user.
 * \details Function which calls the web services users and the method update from the users crud.
 * \param id_user Id of the user.
 * \param nickname Nickname of the user.
 * \param fullname Fullname of the user.
 * \param email Email of the user.
 * \param password Password of the user.
 * \param token Token of the connected user.
 */
- (void) updateUserId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

/**
 * \fn (void) deleteUserWithId:(NSString*)id_user token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Delete user.
 * \details Function which calls the web services users and the method delete from the users crud.
 * \param id_user Id of the user.
 * \param token Token of the connected user.
 */
- (void) deleteUserWithId:(NSString*)id_user token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;


@end
