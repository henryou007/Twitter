//
//  MenuViewController.m
//  Twitter
//
//  Created by Jin You on 11/9/14.
//  Copyright (c) 2014 Henryyou. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *menuOptions;
@property (weak, nonatomic) MainViewController *mainViewController;

@end

@implementation MenuViewController

- (id) initWithMainViewController: (MainViewController *) mainViewController {
    self = [super init];
    if (self) {
        self.mainViewController = mainViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuOptions];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuTableViewCell"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(50.0/255.0) green:(222.0/255.0) blue:1 alpha:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    cell.menuOptionLabel.text = self.menuOptions[indexPath.row][@"title"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuOptions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0){
        [self.mainViewController presentProfile];
    } else if (indexPath.row == 1){
        [self.mainViewController presentHomeTimeline];
    }
    
}

- (void)initMenuOptions {
    self.menuOptions = @[
                         @{@"title" : @"Profile"},
                         @{@"title" : @"Newsfeed"},
                         @{@"title" : @"Mentions"},
                         ];
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
