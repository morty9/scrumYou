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

- (void) addStats:(NSString*)id_project token:(NSString*)token callback:(void (^)(NSError *error, BOOL success))callback;

@end
