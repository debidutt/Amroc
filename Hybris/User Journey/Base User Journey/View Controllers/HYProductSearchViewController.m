//
//  HYProductSearchViewController.m
//  Hybris
//
//  Created by TCS INFINITI on 27/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "HYProductSearchViewController.h"
#import "HYQuery.h"

@interface HYProductSearchViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar * searchNav;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *storeArray;
@property (nonatomic, strong) NSString *currentSearch;




// BOOL to prevent view reload from replacing search results
@property (nonatomic) BOOL hasPerformedSearch;
@property (nonatomic) BOOL shouldBeginEditing;
@end

@implementation HYProductSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f]];
    [self.searchNav setBarTintColor:[UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f]];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tableView.hidden = YES;
    
    
}


- (void)clearTable {
    // if a search is being replaced, wipe the data
    if ([self.storeArray count]) {
        [self.storeArray removeAllObjects];
        self.currentPage = 0;
        [self.tableView reloadData];
    }
}

- (void)displayResultsWithDictionary:(NSArray *)resultArray {
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if ([resultArray count]) {
        for(int i = 0; i<[resultArray count]; i++){
            NSString * stringResult = [resultArray objectAtIndex:i];
            [tempArray addObject:stringResult];
        }
    }
    
    if ([tempArray count]) {
        self.storeArray = [[NSMutableArray alloc]initWithArray:tempArray];
        [self.tableView reloadData];
    }
    
}

#pragma mark - UI search bar delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.currentPage = 0;
    [self loadTableWithData];
    [searchBar resignFirstResponder];
}



-(void)loadTableWithData{
    
    if ([self.searchBar.text length]>3) {
        [[HYWebService shared] searchForAutoComplete:self.searchBar.text completionBlock:^(NSArray *results){
            self.tableView.hidden = NO;
            [self clearTable];
            [self displayResultsWithDictionary:results];
            self.hasPerformedSearch = YES;
            self.currentSearch = self.searchBar.text;
            [self.searchBar setShowsCancelButton:NO animated:YES];
            
        }];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Search string should more than 3 letters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length]>3) {
        // User tapped the 'clear' button.
        _shouldBeginEditing = NO;
        [self loadTableWithData];
        
    }
    
    
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearch];
}


- (void)dismissSearch {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([self.storeArray count]) {
        return [self.storeArray count];
    }
    else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    if ([self.storeArray count]) {
        cell.textLabel.text = [self.storeArray objectAtIndex:indexPath.row];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
