//
//  GetUsers.h
//  Scrummary
//
//  Created by Bérangère La Touche on 13/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface GetUsers : NSObject {
    NSMutableArray<User*>* _users_list;
}

@property (nonatomic, strong)NSMutableArray<User*>* users_list;

- (void) getUsers;

@end
