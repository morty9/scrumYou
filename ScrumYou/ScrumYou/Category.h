//
//  Category.h
//  Scrummary
//
//  Created by Thomas Pain-Surget on 07/07/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject {
    NSString* _id_category;
    NSString* _title;
}

@property (nonatomic, strong) NSString* id_category;
@property (nonatomic, strong) NSString* title;

- (instancetype) initWithId:(NSString*)id_category title:(NSString*)title;

@end
