//
//  TweetsViewController.m
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeTweetViewController.h"
#import "TweetDetailViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * allTweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong,nonatomic) UIRefreshControl *listRefreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    self.tweetsTableView.rowHeight = UITableViewAutomaticDimension;
    
    // Pull to refresh
    self.listRefreshControl = [[UIRefreshControl alloc] init];
    [self.listRefreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView insertSubview:self.listRefreshControl atIndex:0];
    
    // Navigation Bar
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButtonTap)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(29.0/255.0) green:(202.0/255.0) blue:1 alpha:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self loadTweets];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTweets];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    
    Tweet *tweet = self.allTweets[indexPath.row];
    cell.user = tweet.user;
    cell.usernameLabel.text = tweet.user.name;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    cell.timestampLabel.text = [formatter stringFromDate:tweet.createdAt];
    cell.tweetTextLabel.text = tweet.text;
    
    if (tweet.retweeted) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    } else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
    
    if (tweet.favorited) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    } else {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
   
    cell.replyToScreenNames = tweet.inReplyToScreenName;
    cell.tweetID = tweet.tweetID;
    cell.previousViewController = self.navigationController;
    cell.isRetweeted = tweet.retweeted;
    cell.isFavorite = tweet.favorited;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allTweets count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tweet *tweet = self.allTweets[indexPath.row];
    
    TweetDetailViewController *dvc = [[TweetDetailViewController alloc] initWithTweet:tweet];
    dvc.previousViewController = self.navigationController;
    [self.navigationController pushViewController:dvc animated:YES];
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

- (IBAction)onLogout {
    [User logout];
}

- (void)loadTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.allTweets = tweets;
        
        for (Tweet *tweet in tweets) {
            NSLog(@"tweet: %@", tweet.text);
        }
        [self.tweetsTableView reloadData];
        [self.listRefreshControl endRefreshing];
    }];
    
}

- (void)onTweetButtonTap {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ComposeTweetViewController alloc] init]];
    
    [self presentViewController:navi animated:YES completion:nil];
}

@end
