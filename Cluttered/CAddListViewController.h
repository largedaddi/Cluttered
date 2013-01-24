//
//  CAddListViewController.h
//  Cluttered
//
//  Created by Sean Pilkenton on 10/3/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKTextViewController.h"

@protocol CAddListViewControllerDelegate <NSObject>
- (void)dismiss:(BOOL)newList;
@end

@interface CAddListViewController : PLKTextViewController

@property (nonatomic, assign) id<CAddListViewControllerDelegate> delegate;

- (void)insertCancelAndSave;

@end
