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
//@property (nonatomic, weak) IBOutlet UITextView *listAuthoringTextView;
- (void)parseList;
//- (List *)createNewList;
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

//- (List *)createNewList {
//  NSManagedObjectContext *moc = [[ListsDataModel sharedDataModel] mainContext];
//  return [List insertInManagedObjectContext:moc
//                                       name:@""
//                                    details:@""];
//}

- (void)parseList {
  // Create new List object.
  static int count = 0;
  NSManagedObjectContext *moc = [[ListsDataModel sharedDataModel] mainContext];
  List *list = [List insertInManagedObjectContext:moc
                                             name:[NSString stringWithFormat:@"List-%d", ++count]
                                          details:@""];
  
  // Parse text view text.
  NSString *unparsedText = self.authoringTextView.text;
  NSArray *listItems = [unparsedText componentsSeparatedByString:@"\n"];
  
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

- (void)dismiss {
  [self.delegate dismiss];
}

- (IBAction)cancel:(id)sender {
  [self dismiss];
}

- (IBAction)saveNewList:(id)sender {
  //TODO: create new list
  //TODO: save new list
  //  [List insertInManagedObjectContext:];
  [self parseList];
  [self dismiss];
}

@end
