//
//  User.m
//  Scrummary
//
//  Created by Bérangère La Touche on 27/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize id_user = _id_user;
@synthesize nickname = _nickname;
@synthesize fullname = _fullname;
@synthesize email = _email;
@synthesize password = _password;
@synthesize id_tasks = _id_tasks;

/**
 * \fn (instancetype) initWithId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password id_tasks:(NSMutableArray*)id_tasks
 * \brief Initiation of User model.
 * \details Allows to initialize with data an object User.
 * \param id_user String corresponds to the id of the user.
 * \param nickname String corresponds to the nickname of the user.
 * \param fullname String corresponds to the fullname of the user.
 * \param email String corresponds to the email of the user.
 * \param password String corresponds to the password of the user.
 * \param id_tasks Mutable Array corresponds to all tasks of the user.
 */
- (instancetype) initWithId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password id_tasks:(NSMutableArray*)id_tasks {
    self = [super init];
    if(self != nil) {
        self.id_user = id_user;
        self.nickname = nickname;
        self.fullname = fullname;
        self.email = email;
        self.password = password;
        self.id_tasks = id_tasks;
    }
    return self;
}

@end
