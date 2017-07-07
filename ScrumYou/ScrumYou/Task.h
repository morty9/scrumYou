//
//  Task.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 06/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject {
    NSString* _id_task;
    NSString* _title;
    NSString* _description;
    NSString* _difficulty;
    NSString* _priority;
    NSString* _id_category;
    NSString* _color;
    NSString* _businessValue;
    NSString* _duration;
    NSString* _status;
    NSString* _id_creator;
    NSMutableArray* _id_members;
}

@property (nonatomic, strong) NSString* id_task;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* difficulty;
@property (nonatomic, strong) NSString* priority;
@property (nonatomic, strong) NSString* id_category;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, strong) NSString* businessValue;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* id_creator;
@property (nonatomic, strong) NSMutableArray* id_members;

- (instancetype) initWithId:(NSString*)id_task title:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSString*)priority id_category:(NSString*)id_category color:(NSString*)color businessValue:(NSString*)businessValue duration:(NSString*)duration status:(NSString*)status id_creator:(NSString*)id_creator id_members:(NSMutableArray*)id_members;

@end
