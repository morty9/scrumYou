//
//  CrudStats.h
//  Scrummary
//
//  Created by Bérangère La Touche on 22/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stat.h"

@interface CrudStats : NSObject {
    NSDictionary* _dict_error;
    Stat* _stat;
}

@property (nonatomic, strong) Stat* stat;
@property (nonatomic, strong) NSDictionary* dict_error;


/**
 * \fn (void) addStats:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback
 * \brief Add stat to database.
 * \details Function which calls the web services stats and the method create from the stats crud.
 * \param id_project Id of the project.
 * \param token Token of the connected user.
 */
- (void) addStats:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

@end
