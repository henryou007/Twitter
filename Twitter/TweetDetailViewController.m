//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Jin You on 11/2/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeTweetViewController.h"
#import "TwitterClient.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *tweeterProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetFavoriteStatsLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) Tweet *tweet;
- (IBAction)onReplyButtonTap:(id)sender;
- (IBAction)onRetweetButtonTap:(id)sender;
- (IBAction)onFavoriteButtonTap:(id)sender;

@end

@implementation TweetDetailViewController


- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    if (self != nil) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usernameLabel.text = self.tweet.user.name;
    self.screennameLabel.text = self.tweet.user.screenname;
    self.tweetTextLabel.text = self.tweet.text;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy, HH:mm a";
    self.timestampLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    self.tweetFavoriteStatsLabel.text = [NSString stringWithFormat:@"%ld RETWEETS   %ld FAVORITES", (long)self.tweet.retweetCount, self.tweet.favoriteCount];
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
    [self.tweeterProfileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onReplyButtonTap:(id)sender {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ComposeTweetViewController alloc] initWithReplyToScreenNames:self.tweet.inReplyToScreenName]];
    
    [self.previousViewController presentViewController:navi animated:YES completion:nil];
    
}

- (IBAction)onRetweetButtonTap:(id)sender {
    if (!self.tweet.retweeted) {
        [[TwitterClient sharedInstance] retweetWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        }];
    }
    
}

- (IBAction)onFavoriteButtonTap:(id)sender {
    if (!self.tweet.favorited) {
        [[TwitterClient sharedInstance] favoriteWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        }];
    }
}


@end
