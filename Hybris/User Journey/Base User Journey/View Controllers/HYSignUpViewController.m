//
//  HYSignUpViewController.m
//  Hybris
//
//  Created by TCS INFINITI on 09/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSignUpViewController.h"
#import "HYLoginViewController.h"
#import <UIKit/UIKit.h>
#import "HYWebService.h"

@interface HYSignUpViewController()

    
@end

@implementation HYSignUpViewController

#pragma mark - Init

NSString * theTitle;

UISegmentedControl *segmentCtrlGender;


- (IBAction)btnSegmentCtrlGender:(UISegmentedControl*)sender {
    
    theTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];

}

- (IBAction)btnRegister:(id)sender {
    
    NSLog(@"First Name : %@",firstName.text);
    NSLog(@"Last Name : %@",lastName.text);
    NSLog(@"Phone Number : %@",phoneNumber.text);
    NSLog(@"Email Id : %@",emailID.text);
    NSLog(@"Password : %@",password.text);
    NSLog(@"Confirm Password : %@",confirmPassword.text);
    NSLog(@"Gender %@",theTitle);
    
    
    [[HYWebService shared] registerCustomerWithFirstName:firstName.text lastName:lastName.text titleCode:@"mr" login:emailID.text password:password.text mobile:phoneNumber.text gender:theTitle completionBlock:^(NSError *error) {
        
        if (error) {
            [[HYAppDelegate sharedDelegate] alertWithError:error];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"Success alert box title") message:NSLocalizedString(@"User registration successful", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
            [alert show];
            
            [[HYAppDelegate sharedDelegate] setIsLoggedIn:YES];
//            [[HYAppDelegate sharedDelegate] setUsername:[array objectAtIndex:3]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [self waitViewShow:NO];
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button index %i",buttonIndex);
    
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}




- (id)initWithTitle:(NSString *)title {
    if ([title isEqualToString: @"SignUp"]) {
        self.title = title;
//        self.delegate = self;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    
//    [super viewWillAppear:animated];
    
//    [self waitViewShow:YES];
//    [[HYWebService shared] titlesWithCompletionBlock:^(NSArray *array, NSError *error) {
//        [self waitViewShow:NO];
//        
//        if (error) {
//            [[HYAppDelegate sharedDelegate] alertWithError:error];
//        }
//        else {
//            [array writeToPlistFile:@"titles"];
//            NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:array.count];
//            
//            for (NSDictionary *dict in array) {
//                [titles addObject:[dict objectForKey:@"name"]];
//            }
//            
//            self.titles = titles;
//        }
//    }];
}

-(void)viewDidLoad {
    
    segmentCtrlGender.selectedSegmentIndex = -1;
    
    
   
    
}


//- (NSArray *)titles {
//    return [[self.entries objectAtIndex:0] objectForKey:@"values"];
//}


- (void)setTitles:(NSArray *)titles {
//    [[self.entries objectAtIndex:0] setObject:titles forKey:@"values"];
//    [self.tableView reloadData];
}


#pragma mark - FormView Controller Delegate methods
- (void)submitWithArray:(NSArray *)array {
    logDebug(@"%@", array);
    
//    if (![[array objectAtIndex:4] isEqual:[array objectAtIndex:5]]) {
//        UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error alert box title") message:NSLocalizedString(@"Password mismatch", @"Error message for mismatching password") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
//        [alert show];
//}
//    }//        return;
//    }
//    
//    self.navigationItem.rightBarButtonItem.enabled = NO;
//    
//    NSArray *titles = [NSArray readFromPlistFile:@"titles"];
//    NSString *titleCode = nil;
//    
//    for (NSDictionary *dict in titles) {
//        if ([[dict objectForKey:@"name"] isEqualToString:[array objectAtIndex:0]]) {
//            titleCode = [dict objectForKey:@"code"];
//            break;
//        
    
//    [self waitViewShow:YES];
    //    [[HYWebService shared] registerCustomerWithFirstName:[array objectAtIndex:1] lastName:[array objectAtIndex:2] titleCode:titleCode login:[array
    //            objectAtIndex:3] password:[array objectAtIndex:4] completionBlock:^(NSError *error) {
    //            if (error) {
    //                [[HYAppDelegate sharedDelegate] alertWithError:error];
    //                self.navigationItem.rightBarButtonItem.enabled = YES;
    //            }
    //            else {
    //                UIAlertView *alert =
    //                [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"Success alert box title") message:NSLocalizedString(@"User registration successful", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
    //                [alert show];
    //
    //                [[HYAppDelegate sharedDelegate] setIsLoggedIn:YES];
    //                [[HYAppDelegate sharedDelegate] setUsername:[array objectAtIndex:3]];
    //                [self.navigationController popViewControllerAnimated:YES];
    //            }
    //
    //            [self waitViewShow:NO];
    //        }];
}

@end
