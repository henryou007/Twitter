//
//  Tweet.h
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property NSInteger retweetCount;
@property bool retweeted;
@property NSInteger favoriteCount;
@property bool favorited;
@property (nonatomic, strong) NSArray *inReplyToScreenName;
@property (nonatomic, strong) NSString *tweetID;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
@end
