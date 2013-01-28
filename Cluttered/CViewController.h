//
//  CViewController.h
//  Cluttered
//
//  Created by Sean Pilkenton on 9/30/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UICollectionViewController

- (void)loadLists;

// Unwind Segues
- (IBAction)cancelAuthoringUnwindSegue:(UIStoryboardSegue *)segue;
- (IBAction)goBackUnwindSegue:(UIStoryboardSegue *)segue;

@end
