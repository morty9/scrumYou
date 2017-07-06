//
//  UpdateUsers.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUsers : NSObject

- (void) updateUserNickname:(NSString*)nickname fullname:(NSString*)fullname email:(NSString*)email password:(NSString*)password;

@end
