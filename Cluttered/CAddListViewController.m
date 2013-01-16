//
//  CAddListViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 10/3/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "CAddListViewController.h"
#import "ListsDataModel.h"
#import "List.h"
#import "ListItem.h"

@interface CAddListViewController ()
- (void)parseList;
@end

@implementation CAddListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.authoringTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)parseList {
  
  // Parse text view text.
  NSString *unparsedText = self.authoringTextView.text;
  NSArray *listItems = [unparsedText componentsSeparatedByString:@"\n"];
  
  // Create new List object.
  NSManagedObjectContext *moc = [[ListsDataModel sharedDataModel] mainContext];
  List *list = [List insertInManagedObjectContext:moc
                                             name:[NSString stringWithFormat:@"List-%@", listItems[0]]
                                          details:@""];
  
  // Create new ListItems.
  ListItem *listItem = nil;
  for (NSString *li in listItems) {
    listItem = [ListItem insertInManagedObjectContext:moc
                                              details:li
                                             complete:NO
                                                 list:list];
  }
  
  NSError *err = nil;
  if ([moc save:&err]) {
    NSLog(@"save success!!");
  } else {
    NSLog(@"save failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

#pragma mark - IBActions

- (void)dismiss:(BOOL)newList {
  [self.delegate dismiss:newList];
}

- (IBAction)cancel:(id)sender {
  [self dismiss:NO];
}

- (IBAction)saveNewList:(id)sender {
  [self parseList];
  [self dismiss:YES];
}

@end
