//
//  CListViewController.h
//  Cluttered
//
//  Created by Sean Pilkenton on 11/10/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;

@interface CListViewController : UITableViewController

@property (nonatomic, strong) List *list;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *listTitle;

// Unwind Segues
- (IBAction)viewNewListUnwindSegue:(UIStoryboardSegue *)segue;

@end
