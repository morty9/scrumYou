//
//  GetUserById.h
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface GetUserById : NSObject {
    NSMutableArray<User*>* usersList;
    
}

@property (nonatomic, strong) NSMutableArray<User*>* usersList;

- (void) getUserById:(NSString*)userId callback:(void (^)(NSError *error, BOOL success))callback;

@end
