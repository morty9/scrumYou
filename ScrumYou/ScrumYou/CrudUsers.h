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


/*
 *  POST -> add user to database
 */
- (void) addNickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> get all users
 */
- (void) getUsers:(void (^)(NSError *error, BOOL success))callback;
/*
 *  GET -> get user by id
 */
- (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  UPDATE -> update user with id
 */
- (void) updateUserId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password callback:(void (^)(NSError *error, BOOL success))callback;
/*
 *  DELETE -> delete user by id
 */
- (void) deleteUserWithId:(NSString*)id_user callback:(void (^)(NSError *error, BOOL success))callback;


@end
