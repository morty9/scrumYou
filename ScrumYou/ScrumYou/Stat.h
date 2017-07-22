//
//  Stat.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stat : NSObject {
    NSString* _id_stats;
    NSString* _id_project;
}

@property (nonatomic, strong) NSString* id_stats;
@property (nonatomic, strong) NSString* id_project;

- (instancetype) initWithId:(NSString*)id_stats id_project:(NSString*)id_project;
@end
