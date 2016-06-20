//
//  FakeHUD.m
//  UIAnimationSamples
//
//  Created by Ray Wenderlich on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FakeHUD.h"

@implementation FakeHUD

// create a new view from the xib
+ (id) newFakeHUD
{
	UINib *nib = [UINib nibWithNibName:@"FakeHUD" bundle:nil];
	NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    FakeHUD *me = [nibArray objectAtIndex: 0];
	return me;
}

- (IBAction)btnStop
{
	// the following method will be defined and explained later: ignore the warning
	[self removeWithSinkAnimation:40];
}

- (IBAction)btnGo {
    NSString *favString=[[NSUserDefaults standardUserDefaults]objectForKey:@"searchItem"];
    NSString *iconData=[[NSUserDefaults standardUserDefaults]objectForKey:@"searchIcon"];

    [self updateSets:@"favoritesArray":@"favoritesData" :favString:iconData];
    
    [self removeWithSinkAnimation:40];

}

-(void)updateSets :(NSString *)nameKey :(NSString*)dataKey :(NSString *)value :(NSString *)data{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:nameKey];
    NSArray *tempData=[[NSUserDefaults standardUserDefaults]objectForKey:dataKey];
    NSMutableArray *dataArray=[NSMutableArray arrayWithArray:tempData];
    NSMutableArray* itemArray  = [NSMutableArray arrayWithArray:tempArray];
    if (itemArray.count==0) {
        itemArray=[[NSMutableArray alloc] init];
    }
    if(dataArray.count==0){
        dataArray=[[NSMutableArray alloc] init];
    }
    if([self newString:value :tempArray])
    {
        [itemArray addObject:value];
        [dataArray addObject:data];
        [userDefaults setObject:itemArray forKey:nameKey];
        [userDefaults setObject:dataArray forKey:dataKey];
    }else{
        NSLog(@"dont");
    }
}
-(bool)newString: (NSString*)target :(NSArray*)array{
    for (int i =0; i<[array count]; i++) {
        if ([target isEqualToString:[array objectAtIndex:i]]) {
            return false;
        }
    }
    
    return true;
}
@end
