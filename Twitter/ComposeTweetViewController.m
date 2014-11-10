//
//  ComposeTweetViewController.m
//  Twitter
//
//  Created by Jin You on 11/2/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeTweetViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong, nonatomic) UILabel *placeholderLabel;

@property (strong, nonatomic) NSString *replyToString;

@end

@implementation ComposeTweetViewController

- (id) initWithReplyToScreenNames:(NSArray *)screennames {
    self = [super init];
    NSMutableArray *editedScreennames = [NSMutableArray array];
    
    if (self != nil) {
        for (NSString *screenname in screennames) {
            [editedScreennames addObject:[NSString stringWithFormat:@"@%@ ", screenname]];
        }
        self.replyToString = [editedScreennames componentsJoinedByString:@""];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.usernameLabel.text = [User currentUser].name;
    self.screennameLabel.text = [User currentUser].screenname;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[User currentUser].profileImageUrl]];
    
    // Navigation Bar
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonTap)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButtonTap)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    
    // Textview Configuration
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.tweetTextView.frame.size.width, 34.0)];
    [self.placeholderLabel setText:@"Type your tweet here..."];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeholderLabel setTextColor:[UIColor lightGrayColor]];
    self.tweetTextView.delegate = self;
    if (self.replyToString) {
        self.tweetTextView.text = self.replyToString;
    } else {
        [self.tweetTextView addSubview:self.placeholderLabel];
    }
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

- (void)onTweetButtonTap {
    // Issue a network request
    if ([self.tweetTextView hasText]) {
        NSDictionary *tweetParams = @{ @"status":self.tweetTextView.text};
        
        [[TwitterClient sharedInstance] tweetWithParams:tweetParams];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCancelButtonTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    if(![textView hasText]) {
        [textView addSubview:self.placeholderLabel];
    } else if ([[textView subviews] containsObject:self.placeholderLabel]) {
        [self.placeholderLabel removeFromSuperview];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (![textView hasText]) {
        [textView addSubview:self.placeholderLabel];
    }
}

@end
