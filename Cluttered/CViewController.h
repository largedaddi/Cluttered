//
//  CViewController.h
//  Cluttered
//
//  Created by Sean Pilkenton on 9/30/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UICollectionViewController

- (IBAction)cancelAuthoringUnwindSegue:(UIStoryboardSegue *)segue;
- (IBAction)returnHomeUnwindSegue:(UIStoryboardSegue *)segue;

@end
