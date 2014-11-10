//
//  TwitterClient.m
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"aMZLleqBiCf0ihVHcZljFyluA";
NSString * const kTwitterConsumerSecret = @"0BYXtbwy4hojFmKlbfemxpiohwJZxkhQN1aohmHBSIor5RvSo8";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}


- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"henryyoutwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got the request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token!");
        NSLog(@"%@", error);
        
        self.loginCompletion(nil, error);
    }];
    
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        
        NSLog(@"got the access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
        
    }];
    
    
}

- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
        NSLog(@"tweet: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
        NSLog(@"tweet: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)tweetWithParams:(NSDictionary *)params {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweeted!!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)retweetWithID:(NSString *)tweetID completion:(void (^)(NSError *error))completion {
    
    NSDictionary *params = @{@"id":tweetID};
    NSString *requestUrlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID];
    [self POST:requestUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweeted!!");
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(error);
    }];
}

- (void)favoriteWithID:(NSString *)tweetID completion:(void (^)(NSError *error))completion {
    
    NSDictionary *params = @{@"id":tweetID};
    NSString *requestUrlString = @"1.1/favorites/create.json";
    [self POST:requestUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Favorited!!");
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

@end
