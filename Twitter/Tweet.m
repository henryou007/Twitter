//
//  Tweet.m
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.tweetID = dictionary[@"id"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        NSMutableArray *replyToScreenNames = [NSMutableArray array];
        [replyToScreenNames addObject:self.user.screenname];
        
        if (![[NSString stringWithFormat:@"%@", dictionary[@"in_reply_to_screen_name"]] isEqualToString:@"<null>"]) {
            [replyToScreenNames addObject:[NSString stringWithFormat:@"%@", dictionary[@"in_reply_to_screen_name"]]];
        }
        self.inReplyToScreenName = replyToScreenNames;
        
        ;
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
