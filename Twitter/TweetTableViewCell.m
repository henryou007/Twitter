//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "ComposeTweetViewController.h"
#import "TwitterClient.h"

@interface TweetTableViewCell()
- (IBAction)onReplyButtonTap:(id)sender;
- (IBAction)onReweetButtonTap:(id)sender;
- (IBAction)onFavoriteButtonTap:(id)sender;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyButtonTap:(id)sender {
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ComposeTweetViewController alloc] initWithReplyToScreenNames:self.replyToScreenNames]];
        
    [self.tweetsViewController presentViewController:navi animated:YES completion:nil];
    
}

- (IBAction)onReweetButtonTap:(id)sender {
    if (!self.isRetweeted) {
        [[TwitterClient sharedInstance] retweetWithID:self.tweetID completion:^(NSError *error) {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)onFavoriteButtonTap:(id)sender {
    if (!self.isFavorite) {
        [[TwitterClient sharedInstance] favoriteWithID:self.tweetID completion:^(NSError *error) {
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        }];
    }
}
@end
