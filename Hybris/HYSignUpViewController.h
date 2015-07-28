//
//  HYSignUpViewController.h
//  Hybris
//
//  Created by TCS INFINITI on 09/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYWebService.h"



@interface HYSignUpViewController:UIViewController{

    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *emailID;
    IBOutlet UITextField *phoneNumber;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
    IBOutlet UISegmentedControl *segmentCtrlGender;
}

- (IBAction)btnRegister:(id)sender;

- (IBAction)btnSegmentCtrlGender:(id)sender;

- (id)initWithTitle:(NSString *)title;

@end
