//
//  CAddListViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 10/3/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "CAuthorListViewController.h"
#import "ListsDataModel.h"
#import "List.h"
#import "ListItem.h"
#import "CViewController.h"

@interface CAuthorListViewController ()
- (void)parseList;
- (void)createAndSaveImageForList:(List *)list;
@end

@implementation CAuthorListViewController {
  NSDateFormatter *_dateFormatter;
  UIButton *_saveButton;
  UIButton *_cancelButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //  [self.authoringTextView becomeFirstResponder];
  NSLog(@"add list view controller center: %@", NSStringFromCGPoint(self.view.center));
  _dateFormatter = [[NSDateFormatter alloc] init];
  _dateFormatter.dateFormat = @"MM/dd/yyyy";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)parseList {
  // Parse text view text.
  NSString *unparsedText = self.authoringTextView.text;
  NSMutableArray *listItems = [NSMutableArray arrayWithArray:[unparsedText componentsSeparatedByString:@"\n"]];
  
  
  // Create new List object.
  NSManagedObjectContext *moc = [[ListsDataModel sharedDataModel] mainContext];
  List *list = [List insertInManagedObjectContext:moc
                                             name:[NSString stringWithFormat:@"%@", listItems[0]]
                                          details:@""];
  // Remove title
  [listItems removeObjectAtIndex:0];
  
  // Create new ListItems.
  ListItem *listItem = nil;
  for (NSString *li in listItems) {
    listItem = [ListItem insertInManagedObjectContext:moc
                                              details:li
                                             complete:NO
                                                 list:list];
  }
  
  [self createAndSaveImageForList:list];
  
  NSError *err = nil;
  if ([moc save:&err]) {
    NSLog(@"save success!!");
  } else {
    NSLog(@"save failed: %@ %@", [err localizedDescription], [err userInfo]);
  }
}

- (void)createAndSaveImageForList:(List *)list
{
  
  NSLog(@"List: %@", list);
  
  CGSize s = self.view.bounds.size;
  UIGraphicsBeginImageContextWithOptions(s, true, 1.0);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  
  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, s.width, s.height));
  
  
  CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
  //  title
  CGPoint p = CGPointMake(20, 20);
  [list.name drawAtPoint:p withFont:[UIFont fontWithName:@"Avenir Next" size:18.0]];
  
  //  date
  p.y += 26.0;
  [[_dateFormatter stringFromDate:list.date] drawAtPoint:p withFont:[UIFont fontWithName:@"Avenir Next" size:11.0]];
  
  //  list items (up to 9 on iPhone 4)
  p.y += 40.0;
  int limit = (list.listItems.count > 9) ? 9 : list.listItems.count;
  NSArray *listItems = [list.listItems allObjects];
  for (int i = 0; i < limit; i++) {
    ListItem *listItem = [listItems objectAtIndex:i];
    [listItem.details drawAtPoint:p withFont:[UIFont fontWithName:@"Avenir Next" size:16.0]];
    p.y += 36.0;
  }
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  filePath = [filePath stringByAppendingFormat:@"/%@-%f.png", list.name, [NSDate timeIntervalSinceReferenceDate]];
  
  [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
  
  list.imagePath = filePath;
  
}

#pragma mark - Public

- (void)insertCancelAndSave
{
  _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_saveButton addTarget:self
                 action:@selector(saveNewList)
       forControlEvents:UIControlEventTouchUpInside];
  [_saveButton setTitle:@"√"
              forState:UIControlStateNormal];
  [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _saveButton.frame = CGRectMake(self.view.bounds.size.width - 30.0, -20.0, 20.0, 20.0);
  [self.view addSubview:_saveButton];
  
  _saveButton.alpha = 0.0;
  [UIView animateWithDuration:0.25
                        delay:0.25
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _saveButton.alpha = 1.0;
                     _saveButton.center = CGPointMake(_saveButton.center.x,
                                                     _saveButton.center.y + 30.0);
                   } completion:nil];
  
  
  _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_cancelButton addTarget:self
                   action:@selector(unwindToMainScreen)
         forControlEvents:UIControlEventTouchUpInside];
  [_cancelButton setTitle:@"+"
                forState:UIControlStateNormal];
  [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _cancelButton.frame = CGRectMake(-20.0, 10.0, 20.0, 20.0);
  [self.view addSubview:_cancelButton];
  
  _cancelButton.alpha = 0.0;
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _cancelButton.alpha = 1.0;
                     _cancelButton.center = CGPointMake(_cancelButton.center.x + 30.0,
                                                       _cancelButton.center.y);
                   } completion:nil];
}

- (void)removeCancelAndSave:(void(^)(void))onComplete
{
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     _saveButton.alpha = 0.0;
                     _saveButton.center = CGPointMake(self.view.bounds.size.width - 30.0, -20.0);
                   } completion:^(BOOL finished) {
                     [_saveButton removeFromSuperview];
                   }];
  
  [UIView animateWithDuration:0.25
                        delay:0.25
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     _cancelButton.alpha = 0.0;
                     _cancelButton.center = CGPointMake(-20.0, 10.0);
                   } completion:^(BOOL finished) {
                     [_cancelButton removeFromSuperview];
                     onComplete();
                   }];
}

#pragma mark - IBActions

- (void)saveNewList {
  //
  //  Should probably do this in an nsoperation.
  //
  
  //
  [self parseList];
  
  [self unwindToMainScreen];
}

- (void)unwindToMainScreen
{
  
  [self.authoringTextView resignFirstResponder];
  
  
  [self performSegueWithIdentifier:@"cancelAuthoring"
                            sender:nil];
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
  if ([segue.identifier isEqualToString:@"cancelAuthoring"]) {
    CViewController *destinationViewController = (CViewController *)segue.destinationViewController;
    [destinationViewController fetchLists];
  }
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
  NSLog(@"segueForUnwindingToViewController - CAddListViewController");
  return [super segueForUnwindingToViewController:toViewController
                               fromViewController:fromViewController
                                       identifier:identifier];
}

@end
