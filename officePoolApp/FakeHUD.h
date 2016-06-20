//
//  FakeHUD.h
//  UIAnimationSamples
//
//  Created by Ray Wenderlich on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"

@interface FakeHUD : UIView


- (IBAction)btnGo;
-(IBAction)btnStop;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
+ (id) newFakeHUD;
@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
-(void)createViews;
@end