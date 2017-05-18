//
//  Data.h
//  Scrummary
//
//  Created by Bérangère La Touche on 18/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Data : UIViewController {
    
    @private
    NSString* _id_data;
    NSString* _title_data;
    
}

@property (nonatomic, strong) NSString* id_data;
@property (nonatomic, strong) NSString* title_data;

@end
