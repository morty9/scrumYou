//
//  Category.m
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize id_category = _id_category;
@synthesize title = _title;

- (instancetype) initWithId:(NSString*)id_category title:(NSString*)title {
    
    self = [super init];
    
    if (self != nil) {
        self.id_category = id_category;
        self.title = title;
    }
    
    return self;
    
}

@end
