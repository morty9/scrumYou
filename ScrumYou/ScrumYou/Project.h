//
//  Projects.h
//  Scrummary
//
//  Created by Bérangère La Touche on 15/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject {
    NSString* _id_project;
    NSString* _title;
    NSString* _id_creator;
    NSMutableArray* _id_members;
    NSMutableArray* _id_sprints;
    NSString* _status;
}

@property (nonatomic, strong) NSString* id_project;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* id_creator;
@property (nonatomic, strong) NSMutableArray* id_members;
@property (nonatomic, strong) NSMutableArray* id_sprints;
@property (nonatomic, strong) NSString* status;

- (instancetype) initWithId:(NSString*)id_project title:(NSString*)title id_creator:(NSString*)id_creator id_members:(NSMutableArray*)id_members id_sprints:(NSMutableArray*)id_sprints status:(NSString*)status;

@end
