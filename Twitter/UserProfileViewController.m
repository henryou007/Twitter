//
//  UserProfileViewController.m
//  Twitter
//
//  Created by Jin You on 11/9/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ComposeTweetViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "UserHeaderTableViewCell.h"
#import "TweetDetailViewController.h"

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userProfileTableView;
@property (nonatomic, strong) NSArray *allTweets;
@property (strong, nonatomic) UserHeaderTableViewCell *userHeader;
@property (strong, nonatomic) User *user;

@end

@implementation UserProfileViewController


- (id)initWithUser: (User *) user {
    self = [super init];
    
    if (self != nil) {
        self.user = user;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userProfileTableView.dataSource = self;
    self.userProfileTableView.delegate = self;
    [self.userProfileTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    [self.userProfileTableView registerNib:[UINib nibWithNibName:@"UserHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserHeaderTableViewCell"];
    self.userProfileTableView.rowHeight = UITableViewAutomaticDimension;
    
    // Navigation Bar
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButtonTap)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(29.0/255.0) green:(202.0/255.0) blue:1 alpha:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self loadTweets];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTweets];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.allTweets.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 223;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserHeaderTableViewCell *cell = [self.userProfileTableView dequeueReusableCellWithIdentifier:@"UserHeaderTableViewCell"];
        [cell setUserHeaderwithUser:self.user];
        return cell;
    } else {
        TweetTableViewCell *cell = [self.userProfileTableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
        
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        Tweet *tweet = self.allTweets[indexPath.row];
        
        TweetDetailViewController *dvc = [[TweetDetailViewController alloc] initWithTweet:tweet];
        dvc.previousViewController = self.navigationController;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTweetButtonTap {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ComposeTweetViewController alloc] init]];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)loadTweets {
    NSDictionary *params = @{@"user_id":self.user.userID};
    
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        self.allTweets = tweets;
        
        [self.userProfileTableView reloadData];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
