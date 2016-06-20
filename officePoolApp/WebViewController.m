//
//  SecondViewController.m
//  officePoolApp
//
//  Created by Kyle Griffith on 2016-06-16.
//  Copyright © 2016 Kyle Griffith. All rights reserved.
//

#import "WebViewController.h"
#import "SearchViewController.h"
@interface  WebViewController()

@end

@implementation WebViewController{

    
    UIScrollView *myScrollView;
    UIWebView *_webView;
    UIView *view;
    NSString *failedImageString;
    UIBarButtonItem *infoButton;
    FakeHUD *theSubView;

}

@synthesize searchString,searchIcon,loadingActivity;



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    theSubView=nil;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title= @"Wikipedia";
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    [self getWiki];
    NSString *urlString=[self analyzeString];
    NSLog(@"%@",urlString);
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    webView.scalesPageToFit=YES;
    [self.view addSubview:webView];
    infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"+" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(btnHUD)];
    self.navigationItem.rightBarButtonItem = infoButton;

    
}
-(NSString*)analyzeString{
    NSString *rootString=@"https://en.wikipedia.org/w/index.php?search=";
    NSString *trimmedSearchString = [searchString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];

    NSString *wikiBaseString = [trimmedSearchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *completeString=[rootString stringByAppendingString:wikiBaseString];
    return completeString;
}

- (void) btnHUD
{
    if (theSubView==nil) {
        theSubView = [FakeHUD newFakeHUD];
        theSubView.searchLabel.text=[NSString stringWithFormat:@" Add %@ to favorites?",searchString];
        theSubView.myIcon.image=searchIcon;
        
        [self.view addSubviewWithFadeAnimation:theSubView duration:1.0 option:UIViewAnimationOptionCurveEaseOut];
    }
    

}
-(bool)hasSpaces :(NSString*)foo{
    NSRange whiteSpaceRange = [foo rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        return true;
    }else{
        return false;
    }
}
-(void)getWiki{

    WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
    wikiHelper.apiUrl = @"http://en.wikipedia.org";
    wikiHelper.delegate = self; // For the new version, we have to set the delegate class
    NSString *searchItem = [searchString stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *apiUrl = @"http://en.wikipedia.org";
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=revisions&titles=%@&rvprop=content&rvparse&format=json&redirects", apiUrl, searchItem];
    if (![self validateUrl:url]){
        searchIcon=[UIImage imageNamed:@"wikiLogo.png"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:searchItem forKey:@"searchItem"];
    if (![self hasSpaces:searchItem]) {
        [wikiHelper fetchArticle:searchItem];
    }
    loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivity startAnimating];
    loadingActivity.hidden = FALSE;
}
- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
- (void)dataLoaded:(NSString *)htmlPage withUrlMainImage:(NSString *)urlMainImage {
     NSString *badLink = @"http://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Ambox_important.svg/40px-Ambox_important.svg.png";

    
    if(![urlMainImage isEqualToString:@""]&&![urlMainImage isEqualToString:badLink])
    {
        NSLog(@"%@",urlMainImage);
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlMainImage]];
        searchIcon= [UIImage imageWithData:imageData];
    }
    else
    {
        searchIcon=NULL;
    }
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(searchIcon)];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"searchIcon"];
    [self btnHUD];

    
}

@end
