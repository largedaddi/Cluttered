//
//  CAuthoringUnwindSegue.m
//  Cluttered
//
//  Created by Sean Pilkenton on 1/13/13.
//  Copyright (c) 2013 Pilks. All rights reserved.
//

#import "CAuthoringUnwindSegue.h"
#import "CViewController.h"
#import "CAuthorListViewController.h"

@implementation CAuthoringUnwindSegue

- (void)perform
{
  CAuthorListViewController *source = (CAuthorListViewController *)self.sourceViewController;
  CViewController *destination = (CViewController *)self.destinationViewController;
  
  [source removeCancelAndSave:^{
    [UIView animateWithDuration:0.25 animations:^{
      
    } completion:^(BOOL finished) {
      [destination dismissViewControllerAnimated:NO completion:^{
        [destination groupInsert];
      }];
    }];
    
  }];
}

@end
