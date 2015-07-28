//
//  HYHomeViewController.m
//  Hybris
//
//  Created by TCS INFINITI on 22/07/15.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYStoreSearchViewController.h"
#import "HYBanner.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HYHomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *storeLocatorBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *profileName;

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation HYHomeViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame.size.width = self.scrollView.frame.size.width;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageImages = [[NSMutableArray alloc] init];
    self.title = @"Paged";
    self.profileName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfileName"];
    [self getBanner];
    
    
   
    
}


- (void)getBanner{
    [[HYWebService shared] getDataForBanner:@"banner" completionBlock:^(NSArray *results) {
      if (results) {
           for (int i=0; i<[results count]; i++) {
               HYBanner * banner = [results objectAtIndex:i];
               
                NSString * FullImageString = banner.imageUrl;
               UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:FullImageString]]];
               NSLog(@"image is %@",img);
               [self.pageImages addObject:img];
                NSLog(@"value for the key is  : - %@", [self.pageImages objectAtIndex:i]);
               banner = nil;
            }
        }
        
       
        NSInteger pageCount = self.pageImages.count;
        
        // Set up the page control
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = pageCount;
        
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
        
         [self loadVisiblePages];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       self.navigationController.navigationBarHidden = YES;
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touch detected");
    
    NSArray *subviews = [self.view subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    // Enumerate over all the touches and draw a red dot on the screen where the touches were
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        
        // Draw a red circle where the touch occurred
        
        NSLog(@"touch are  %f",touchPoint.y);
        
    }];
    
    }

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
       }

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
        
   }
*/

-(IBAction)mailToCromaTeam:(id)sender{
    
    MFMailComposeViewController *mailComposer;
    
    //mail composer is used to send mail
   
    if ([MFMailComposeViewController canSendMail]){
    mailComposer  = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects:@"indrajeet.tiwari@tcs.com", nil]];
    [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
    [mailComposer setSubject:@"Message"];
    [mailComposer setMessageBody:@"your custom body content" isHTML:NO];
    //[self.navigationController pushViewController:mailComposer animated:YES];
    [self presentViewController:mailComposer animated:YES completion:NULL];
    }
    else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please configure your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if(error) NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:NULL];
    return;
}

-(IBAction)callToCallCenter:(id)sender{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"9004800506"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}


@end
