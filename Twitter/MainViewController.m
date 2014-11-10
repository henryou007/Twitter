//
//  MainViewController.m
//  Twitter
//
//  Created by Jin You on 11/9/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "UserProfileViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UINavigationController *menuVC;
@property (strong, nonatomic) UINavigationController *homeTimelineVC;
@property (strong, nonatomic) UINavigationController *userProfileVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuVC = [[UINavigationController alloc] initWithRootViewController:[[MenuViewController alloc] initWithMainViewController:self]];
    self.homeTimelineVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    self.userProfileVC = [[UINavigationController alloc] initWithRootViewController:[[UserProfileViewController alloc] initWithUser:[User currentUser]]];
    
    self.containerView = [[UIView alloc] initWithFrame:self.scrollView.frame];
    [self.containerView addSubview:self.homeTimelineVC.view];
    
    
    CGRect frame = self.scrollView.bounds;
    self.menuVC.view.frame = frame;
    [self.scrollView addSubview:self.menuVC.view];
    
    frame.origin.x += 250;
    self.containerView.frame = frame;
    [self.scrollView addSubview:self.containerView];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.homeTimelineVC.view.bounds];
    self.homeTimelineVC.view.layer.masksToBounds = NO;
    self.homeTimelineVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.homeTimelineVC.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.homeTimelineVC.view.layer.shadowOpacity = 0.5f;
    self.homeTimelineVC.view.layer.shadowPath = shadowPath.CGPath;
    
    self.scrollView.contentSize = CGSizeMake(320 + 250, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(250, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentHomeTimeline {
    [self.containerView addSubview:self.homeTimelineVC.view];
}

- (void)presentProfile {
    [self.containerView addSubview:self.userProfileVC.view];
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
