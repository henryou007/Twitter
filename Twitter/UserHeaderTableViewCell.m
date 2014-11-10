//
//  UserHeaderTableViewCell.m
//  Twitter
//
//  Created by Jin You on 11/9/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "UserHeaderTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface UserHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *numTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;


@end

@implementation UserHeaderTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserHeaderwithUser:(User *)user {
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:user.profileBackgroundImageUrl]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.numFollowerLabel.text = user.followers_count;
    self.numFollowingLabel.text = user.following_count;
    self.numTweetLabel.text = user.tweet_count;
    self.userNameLabel.text = user.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];

}

@end
