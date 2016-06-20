//
//  FirstViewController.m
//  officePoolApp
//
//  Created by Kyle Griffith on 2016-06-16.
//  Copyright © 2016 Kyle Griffith. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"
#import "WikipediaHelper.h"
@interface SearchViewController ()<WebViewControllerDelegate>

@end

@implementation SearchViewController{
    UITextField *searchField;
    UIScrollView *myScrollView;
    UIButton *searchButton;
    bool keyboardIsShown;
    UIImage *searchImage;
    UIActivityIndicatorView *loadingActivity;

}

- (void)viewDidLoad {
    [super viewDidLoad];

 // NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [searchField addTarget:self
                       action:@selector(dismissKeyboard)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    myScrollView.contentSize = scrollContentSize;
    
    [self createViews];
    

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)dataFromController:(bool)newData;
{
    newData=true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initScrollView{
    myScrollView.delegate = self;
    myScrollView.scrollEnabled = YES;
    
    int scrollWidth = 120;
    myScrollView.contentSize = CGSizeMake(scrollWidth,80);
}
-(void)createViews{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    CGFloat imageWidth= screenwidth/2;
    CGFloat headerHeight= imageWidth*146/400;
    CGFloat buttonDim=screenwidth/8;
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view =  myScrollView;
    [myScrollView setBackgroundColor:[UIColor whiteColor]];
    CGSize pageSize=CGSizeMake(screenwidth, screenheight);
    [myScrollView setContentSize:pageSize];

    //Image
     UIImageView *wikiLogo =[[UIImageView alloc] initWithFrame:CGRectMake(screenwidth/4,screenheight/8,imageWidth,imageWidth)];
    wikiLogo.image=[UIImage imageNamed:@"wikiLogo.png"];
    [myScrollView addSubview:wikiLogo];
    UIImageView *wikiHeader =[[UIImageView alloc] initWithFrame:CGRectMake(screenwidth/4,screenheight/2.1,imageWidth,headerHeight)];
    wikiHeader.image=[UIImage imageNamed:@"WikiHeader.png"];
    [myScrollView addSubview:wikiHeader];
    //TextField
    CGRect frame = CGRectMake(screenwidth/6-buttonDim/2, screenheight/1.7,screenwidth*2/3, buttonDim);
    searchField = [[UITextField alloc] initWithFrame:frame];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.textColor = [UIColor blackColor];
    searchField.font = [UIFont systemFontOfSize:24.0];
    searchField.placeholder = @"SEARCH";
    searchField.backgroundColor = [UIColor clearColor];
    searchField.autocorrectionType = UITextAutocorrectionTypeYes;
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    searchField.textAlignment = NSTextAlignmentCenter;
    [searchField setKeyboardType:UIKeyboardTypeAlphabet];
    [searchField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [searchField.layer setBorderWidth:2.0];
    [searchField setReturnKeyType:UIReturnKeyDone];

    searchField.layer.cornerRadius = 5;
    searchField.clipsToBounds = YES;
    
    [myScrollView addSubview:searchField];
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self
                action:@selector(passDataForward)
      forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"SearchButton"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"SearchButtonPressed"] forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(screenwidth*5/6-buttonDim/2, screenheight/1.7, buttonDim,buttonDim);
    [searchButton setBackgroundColor:[UIColor redColor]];
    searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    [myScrollView addSubview:searchButton];
}

- (void)passDataForward
{
    if([searchField.text isEqualToString:@""]){
        [self showView];
    }else{

        WebViewController *secondViewController =[[WebViewController alloc] init];
        secondViewController.delegate=self;
        secondViewController.searchString=searchField.text;
        [self.navigationController pushViewController:secondViewController animated:YES];
    }
}


-(void)getWiki{
    WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
    wikiHelper.apiUrl = @"http://en.wikipedia.org";
    wikiHelper.delegate = self; // For the new version, we have to set the delegate class
    NSString *searchWord = [searchField.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    
    [wikiHelper fetchArticle:searchWord];
    loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivity startAnimating];
    loadingActivity.hidden = FALSE;
}
- (void)dataLoaded:(NSString *)htmlPage withUrlMainImage:(NSString *)urlMainImage {
    
    
    if(![urlMainImage isEqualToString:@""]) {
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlMainImage]];
        searchImage= [UIImage imageWithData:imageData];
        
    }else{
        searchImage=[UIImage imageNamed:@"wikiLogo.png"];
    }
    [loadingActivity stopAnimating];
    loadingActivity.hidden = TRUE;

}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize themyScrollView
    CGRect viewFrame = myScrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    CGFloat kTabBarHeight= self.navigationController.navigationBar.frame.size.height;

    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [myScrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = myScrollView.frame;
    CGFloat kTabBarHeight= self.navigationController.navigationBar.frame.size.height;

    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [myScrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}
-(void)dismissKeyboard {
    [searchField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showView {
    // Create a view with the size and position of the tapped button
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    CGRect initalFrame=CGRectMake(0,-screenheight/5,screenwidth, screenheight/10);
    UIView *view = [[UIView alloc] initWithFrame:initalFrame];
    // Set a color on the view
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, screenheight/10)];
    [lable setText:[NSString stringWithFormat:@"Enter your search choice"]];
    [lable setFont:[UIFont systemFontOfSize:16.0f]];
    [lable setTextAlignment:NSTextAlignmentCenter];
    lable.textColor=[UIColor blackColor];
    [view addSubview:lable];
    [self.view addSubview:view];
    CGRect finishingFrame = CGRectMake(0,0,screenwidth,screenheight/10);
    
    [UIView animateWithDuration:.5 animations:^{
        view.frame = finishingFrame;
    }completion:^(BOOL finished) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:.5 animations:^{
                view.frame=initalFrame;
                
            }];
        });
    }];
}
@end
