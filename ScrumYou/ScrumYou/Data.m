//
//  Data.m
//  Scrummary
//
//  Created by Bérangère La Touche on 18/05/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "Data.h"

@interface Data ()

@end

@implementation Data

@synthesize id_data = _id_data;
@synthesize title_data = _title_data;

- (instancetype) initWithId:(NSString*)id_data title:(NSString*)title_data {
    self = [super init];
    if(self != nil) {
        self.id_data = id_data;
        self.title_data = title_data;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
