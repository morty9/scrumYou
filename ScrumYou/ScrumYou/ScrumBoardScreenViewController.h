//
//  ScrumBoardScreenViewController.h
//  ScrumYou
//
//  Created by Bérangère La Touche on 08/03/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrumBoardScreenViewController : UIViewController {
    
    NSString* _id_project;
    
}

@property (weak, nonatomic) IBOutlet UIButton *startAgain;
@property (nonatomic, strong) NSString* id_project;

@end
