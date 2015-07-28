//
//  HYPageContentViewController.h
//  Hybris
//
//  Created by TCS INFINITI on 17/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#include "HYPageContentViewController.h"

@interface HYPageContentViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

- (void)previousPage;
- (void)nextPage;
@end
