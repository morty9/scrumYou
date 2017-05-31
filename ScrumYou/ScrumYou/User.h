//
//  User.h
//  Scrummary
//
//  Created by Bérangère La Touche on 27/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString* _id_user;
    NSString* _nickname;
    NSString* _fullname;
    NSString* _email;
    NSString* _password;
    NSMutableArray* _id_tasks;
}

@property (nonatomic, strong) NSString* id_user;
@property (nonatomic, strong) NSString* nickname;
@property (nonatomic, strong) NSString* fullname;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSMutableArray* id_tasks;

- (instancetype) initWithId:(NSString*)id_user nickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password id_tasks:(NSMutableArray*)id_tasks;

@end
