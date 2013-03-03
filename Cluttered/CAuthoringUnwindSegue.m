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
    [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
  }];
  
}

@end
