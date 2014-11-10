//
//  User.h
//  Twitter
//
//  Created by Jin You on 11/1/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *following_count;
@property (nonatomic, strong) NSString *followers_count;
@property (nonatomic, strong) NSString *tweet_count;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

+ (void)logout;

@end
