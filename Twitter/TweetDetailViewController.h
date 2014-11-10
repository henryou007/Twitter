//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Jin You on 11/2/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetsViewController.h"

@interface TweetDetailViewController : UIViewController

@property (weak, nonatomic) UINavigationController *previousViewController;

- (id)initWithTweet:(Tweet *)tweet;

@end
