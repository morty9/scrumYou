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
