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
//  [self.authoringTextView becomeFirstResponder];
  NSLog(@"add list view controller center: %@", NSStringFromCGPoint(self.view.center));
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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

#pragma mark - Public

- (void)insertCancelAndSave
{
  UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [saveButton addTarget:self
                 action:@selector(transitionToAuthorList)
       forControlEvents:UIControlEventTouchUpInside];
  [saveButton setTitle:@"√"
              forState:UIControlStateNormal];
  [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  saveButton.frame = CGRectMake(self.view.bounds.size.width - 30.0, -20.0, 20.0, 20.0);
  [self.view addSubview:saveButton];
  
  saveButton.alpha = 0.0;
  [UIView animateWithDuration:0.25
                        delay:0.25
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     saveButton.alpha = 1.0;
                     saveButton.center = CGPointMake(saveButton.center.x,
                                                     saveButton.center.y + 30.0);
                   } completion:nil];
  
  
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton addTarget:self
                 action:@selector(transitionToAuthorList)
       forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:@"+"
              forState:UIControlStateNormal];
  [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  cancelButton.frame = CGRectMake(-20.0, 10.0, 20.0, 20.0);
  [self.view addSubview:cancelButton];
  
  cancelButton.alpha = 0.0;
  [UIView animateWithDuration:0.25
                        delay:0.25
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     cancelButton.alpha = 1.0;
                     cancelButton.center = CGPointMake(cancelButton.center.x + 30.0,
                                                     cancelButton.center.y);
                   } completion:nil];
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

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
  return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
  if ([segue.identifier isEqualToString:@""]) {
    
  }
}

@end
