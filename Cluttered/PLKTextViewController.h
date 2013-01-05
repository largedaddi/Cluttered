//
//  PLKTextViewController.h
//  Cluttered
//
//  Created by Sean Pilkenton on 10/8/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLKTextViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *authoringTextView;
@end
