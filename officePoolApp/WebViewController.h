//
//  SecondViewController.h
//  officePoolApp
//
//  Created by Kyle Griffith on 2016-06-16.
//  Copyright © 2016 Kyle Griffith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FakeHUD.h"
#import "WikipediaHelper.h"

@protocol WebViewControllerDelegate <NSObject>

@required
- (void)dataFromController:(bool)newData;

@end

@interface WebViewController : UIViewController<WikipediaHelperDelegate>{
    int	selectedCurveIndex;

}
@property NSString *searchString;
@property UIImage *searchIcon;
@property (nonatomic, weak) id<WebViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivity;


@end

