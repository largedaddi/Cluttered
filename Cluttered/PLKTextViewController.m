//
//  PLKTextViewController.m
//  Cluttered
//
//  Created by Sean Pilkenton on 10/8/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "PLKTextViewController.h"

@interface PLKTextViewController () {
  BOOL _portrait;
}
- (void)removeKeyboardObservers;
@end

@implementation PLKTextViewController

- (void)commonInit {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self determineOrientation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self removeKeyboardObservers];
}

- (void)dealloc {
  [self removeKeyboardObservers];
}

#pragma mark - Instance

- (void)removeKeyboardObservers {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)scrollToCursor {
  CGRect cursorPosition = [self.authoringTextView caretRectForPosition:self.authoringTextView.selectedTextRange.start];
  if (!CGRectContainsPoint(self.authoringTextView.frame, cursorPosition.origin)) {
    cursorPosition.size.height += 8;
    [self.authoringTextView scrollRectToVisible:cursorPosition animated:YES];
  }
}

- (void)determineOrientation {
  UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
  switch (currentOrientation) {
    case UIDeviceOrientationLandscapeLeft:
    case UIDeviceOrientationLandscapeRight:
      _portrait = NO;
      break;
    default:
      _portrait = YES;
      break;
  }
}

#pragma mark - Observers

- (void)keyboardWasShown:(NSNotification *)notification {
  NSDictionary *d = [notification userInfo];
  CGRect kbFrame = [[d objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  CGRect viewFrame = self.view.frame;
  [self determineOrientation];
  viewFrame.size.height -= (_portrait) ? kbFrame.size.height : kbFrame.size.width;
  self.authoringTextView.frame = viewFrame;
  [self scrollToCursor];
}

- (void)keyboardWillHide:(NSNotification *)notification {

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
  [self scrollToCursor];
}

@end
