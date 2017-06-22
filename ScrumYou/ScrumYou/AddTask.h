//
//  AddTask.h
//  Scrummary
//
//  Created by Bérangère La Touche on 14/06/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddTask : NSObject

- (void) addTaskTitle:(NSString*)title description:(NSString*)description difficulty:(NSString*)difficulty priority:(NSNumber*)priority id_category:(NSNumber*)id_category color:(NSString*)color businessValue:(NSString*)businessValue duration:(NSString*)duration id_members:(NSMutableArray*)id_member;

@end
