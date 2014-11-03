//
//  TwitterClient.h
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)tweetWithParams:(NSDictionary *)params;

- (void)retweetWithID:(NSString *)tweetID completion:(void (^)(NSError *error))completion;

- (void)favoriteWithID:(NSString *)tweetID completion:(void (^)(NSError *error))completion;
@end
