//
//  Sprint.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sprint : NSObject {
    NSString* _id_sprint;
    NSString* _title;
    NSString* _beginningDate;
    NSDate* _endDate;
    NSString* _id_creator;
    NSMutableArray* _id_listTasks;
}

@property (nonatomic, strong) NSString* id_sprint;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* beginningDate;
@property (nonatomic, strong) NSDate* endDate;
@property (nonatomic, strong) NSString* id_creator;
@property (nonatomic, strong) NSMutableArray* id_listTasks;

- (instancetype) initWithId:(NSString*)id_sprint title:(NSString*)title beginningDate:(NSString*)beginningDate endDate:(NSDate*)endDate id_creator:(NSString*)id_creator id_listTasks:(NSMutableArray*)id_listTasks;

@end
