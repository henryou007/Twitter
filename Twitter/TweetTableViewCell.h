//
//  TweetTableViewCell.h
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetsViewController.h"

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) TweetsViewController *tweetsViewController;
@property (weak, nonatomic) NSArray *replyToScreenNames;
@property (strong, nonatomic) NSString *tweetID;
@property bool isRetweeted;
@property bool isFavorite;

@end
