//
//  HYLandingPageViewController.m
//  Hybris
//
//  Created by TCS INFINITI on 17/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "HYLandingPageViewController.h"

@interface HYLandingPageViewController ()
@end


@implementation HYLandingPageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Do any additional setup after loading the view.
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View2"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View3"]];
    
    
    
}


@end